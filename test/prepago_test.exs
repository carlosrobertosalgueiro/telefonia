defmodule PrepagoTest do
  use ExUnit.Case

  doctest Prepago

  setup do
    File.write("pre.txt", :erlang.term_to_binary([]))
    File.write("pos.txt", :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm("pre.txt")
      File.rm("pos.txt")
    end)
  end

  describe "Estrutura do prepago" do
    test "Testando estrutura prepago" do
      assert %Prepago{creditos: 5, recargas: ["1", "2"]}.creditos == 5
    end
  end

  describe "Funções de ligação" do
    test "Fazer uma ligação" do
      Assinante.cadastrar("carlos", "123", "123", :prepago)
      Recarga.nova(DateTime.utc_now(), 10, "123")

      assert Prepago.fazer_chamada("123", DateTime.utc_now(), 3) ==
               {:ok, "A chamada custou 4.35, e você tem 5.65 de creditos"}
    end

    test "Deve fazer uma ligação longa e não tem creditos" do
      Assinante.cadastrar("carlos", "123", "123", :prepago)

      assert Prepago.fazer_chamada("123", DateTime.utc_now(), 10) ==
               {:error, "você não tem creditos suficiente, faça uma recarga"}
    end
  end

  describe "Impressão de contas" do
    test "fazer impressão de contas" do
      Assinante.cadastrar("carlos", "123", "123", :prepago)
      data = DateTime.utc_now()
      data_antiga = ~U[2022-06-03 16:49:00.606990Z]

      Recarga.nova(data, 10, "123")
      Prepago.fazer_chamada("123", data, 3)

      Recarga.nova(data_antiga, 10, "123")
      Prepago.fazer_chamada("123", data_antiga, 3)

      assinante = Assinante.buscar_assinantes("123", :prepago)

      assert Enum.count(assinante.chamadas) == 2
      assert Enum.count(assinante.plano.recargas) == 2

      assinante = Prepago.imprimir_conta(data.month, data.year, "123")

      assert assinante.numero == "123"
      assert Enum.count(assinante.chamadas) == 1
      assert Enum.count(assinante.plano.recargas) == 1
    end
  end
end
