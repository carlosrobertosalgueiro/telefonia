defmodule TelefoniaTest do
  use ExUnit.Case
  # doctest Telefonia

  setup do
    File.write("pre.txt", :erlang.term_to_binary([]))
    File.write("pos.txt", :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm("pre.txt")
      File.rm("pos.txt")
    end)
  end

  test "Função start deve retornar um :ok " do
    assert Telefonia.start() == :ok
  end

  test "Retorna estrutura de assinates" do
    assert Telefonia.cadastrar_assinante("Carlos", "123", "123", :prepago) ==
             {:ok, "Assinante Carlos cadastrado com sucesso!"}
  end

  test "Deve listar todos os assinantes cadastrados" do
    Telefonia.cadastrar_assinante("Carlos", "123", "123", :prepago)

    assert Telefonia.listar_assinantes() == [
             %Assinante{
               chamadas: [],
               cpf: "123",
               nome: "Carlos",
               numero: "123",
               plano: %Prepago{creditos: 0, recargas: []}
             }
           ]
  end

  test "Deve listar assinantes do tipo prepago" do
    Telefonia.cadastrar_assinante("Carlos", "123", "123", :prepago)
    Telefonia.cadastrar_assinante("Bruce", "1234", "1234", :pospago)

    assert Telefonia.listar_assinantes_prepago() == [
             %Assinante{
               chamadas: [],
               cpf: "123",
               nome: "Carlos",
               numero: "123",
               plano: %Prepago{creditos: 0, recargas: []}
             }
           ]
  end

  test "Deve listar assinantes do tipo pospago" do
    Telefonia.cadastrar_assinante("Carlos", "123", "123", :prepago)
    Telefonia.cadastrar_assinante("Bruce", "1234", "1234", :pospago)

    assert Telefonia.listar_assinantes_pospago() == [
             %Assinante{
               chamadas: [],
               cpf: "1234",
               nome: "Bruce",
               numero: "1234",
               plano: %Pospago{valor: 0}
             }
           ]
  end

  describe "Testando ligações" do
    test "Deve fazer uma chamada" do
      Telefonia.cadastrar_assinante("Bruce", "1234", "1234", :pospago)
      Telefonia.cadastrar_assinante("Carlos", "123", "123", :prepago)
      Recarga.nova(DateTime.utc_now(), 10, "123")

      assert Telefonia.fazer_chamada("1234", :pospago, DateTime.utc_now(), 3) ==
               {:ok, "Chamada feita com sucesso! Duração 3 minutos"}

      assert Telefonia.fazer_chamada("123", :prepago, DateTime.utc_now(), 3) ==
               {:ok, "A chamada custou 4.35, e você tem 5.65 de creditos"}
    end

    test "Tenta fazer uma ligação sem saldo disponivel tipo prepago" do
      Telefonia.cadastrar_assinante("Carlos", "123", "123", :prepago)

      assert Telefonia.fazer_chamada("123", :prepago, DateTime.utc_now(), 3) ==
               {:error, "você não tem creditos suficiente, faça uma recarga"}
    end
  end

  test "Realiza uma recarga" do
    Telefonia.cadastrar_assinante("Carlos", "123", "123", :prepago)

    assert Telefonia.recarga("123", DateTime.utc_now(), 50) ==
             {:ok, "Recarga realizada com sucesso"}
  end

  test "Deve reportar o cliente expecificado" do
    Telefonia.cadastrar_assinante("Bruce", "1234", "1234", :pospago)
    Telefonia.cadastrar_assinante("Carlos", "123", "123", :prepago)

    assert Telefonia.buscar_por_numero("1234", :pospago).cpf == "1234"
    assert Telefonia.buscar_por_numero("123", :prepago).nome == "Carlos"
  end

  test "Imprimir contas" do
    Telefonia.cadastrar_assinante("Bruce", "1234", "1234", :pospago)
    Telefonia.cadastrar_assinante("Carlos", "123", "123", :prepago)

    Recarga.nova(DateTime.utc_now(), 10, "123")
    Telefonia.fazer_chamada("123", :prepago, DateTime.utc_now(), 3)
    Telefonia.fazer_chamada("1234", :pospago, DateTime.utc_now(), 3)

    # Telefonia.listar_assinantes_prepago()
    # Telefonia.listar_assinantes_pospago()

    date = DateTime.utc_now()

    assert Telefonia.imprimir_contas(date.month, date.year) == :ok
  end
end
