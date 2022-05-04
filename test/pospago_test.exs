defmodule PospagoTest do
  use ExUnit.Case

  setup do
    File.write("pre.txt", :erlang.term_to_binary([]))
    File.write("pos.txt", :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm("pre.txt")
      File.rm("pos.txt")
    end)
  end

  describe "Estrutura de Pospago" do
    test "Testando estrutado pospago" do
      assert %Pospago{valor: 50}.valor == 50
    end
  end

  describe "Teste de ligação Pospago" do
    test "fazer uma chamada" do
      Assinante.cadastrar("carlos", "123", "123", :pospago)

      assert Pospago.fazer_chamada("123", DateTime.utc_now(), 5) ==
               {:ok, "Chamada feita com sucesso! Duração 5 minutos"}
    end
  end

  describe "Impressão de contas" do
    test "fazer impressão de contas" do
      Assinante.cadastrar("carlos", "123", "123", :pospago)
      data = DateTime.utc_now()
      data_antiga = ~U[2022-06-03 16:49:00.606990Z]

      Pospago.fazer_chamada("123", data, 3)
      Pospago.fazer_chamada("123", data, 3)
      Pospago.fazer_chamada("123", data, 3)
      Pospago.fazer_chamada("123", data_antiga, 3)

      assinante = Assinante.buscar_assinantes("123", :pospago)

      assert Enum.count(assinante.chamadas) == 4

      assinante = Pospago.imprimir_conta(data.month, data.year, "123")

      assert assinante.numero == "123"
      assert Enum.count(assinante.chamadas) == 3
      assert assinante.plano.valor == 12.0
    end
  end
end
