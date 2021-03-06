defmodule AssinanteTest do
  use ExUnit.Case

  doctest Assinante

  setup do
    File.write("pre.txt", :erlang.term_to_binary([]))
    File.write("pos.txt", :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm("pre.txt")
      File.rm("pos.txt")
    end)
  end

  describe "Testes responsaveis pelo cadastro de assinantes" do
    test "retorna estrutura de assinates" do
      assert %Assinante{nome: "teste", numero: "teste", cpf: "teste", plano: "plano"}.nome ==
               "teste"
    end

    test "cadastar assinante" do
      assert Assinante.cadastrar("carlos", "123", "123", :prepago) ==
               {:ok, "Assinante carlos cadastrado com sucesso!"}
    end

    test "Retornarr error dizendo que o assinante já está cadastrado" do
      assert Assinante.cadastrar("carlos", "123", "123", :prepago)

      assert Assinante.cadastrar("carlos", "123", "123", :prepago) ==
               {:error, "Assinante carlos já cadastrado"}
    end
  end

  describe "testes responsaveis pela busca de assinates" do
    test "buscar pospagos" do
      Assinante.cadastrar("carlos", "123", "123", :pospago)

      assert Assinante.buscar_assinantes("123", :pospago).nome == "carlos"
    end

    test "buscar prepagos" do
      Assinante.cadastrar("bruce", "123", "123", :prepago)

      assert Assinante.buscar_assinantes("123", :prepago).nome == "bruce"
      assert Assinante.buscar_assinantes("123", :prepago).plano.__struct__ == Prepago
    end
  end

  describe "atualizar assinante" do
    test "Deve atualizar assinante" do
      Telefonia.cadastrar_assinante("Carlos", "123", "123", :prepago)
      assinante = Assinante.buscar_assinantes("123")
      assinante_atualizado = %Assinante{assinante | nome: "Carlos Roberto"}
      assert Assinante.atualizar("123", assinante_atualizado) == :ok
    end
  end

  describe "delete" do
    test "deleta o assinante" do
      Assinante.cadastrar("Bruce", "123", "1231", :prepago)
      Assinante.cadastrar("Alvin", "345", "1234", :prepago)

      assert Assinante.deletar("123") == {:ok, "Assinante Bruce deletado!"}
    end
  end
end
