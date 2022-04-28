defmodule AssinanteTest do
  use ExUnit.Case

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
      assert %Assinante{nome: "teste", numero: "teste", cpf: "teste", plano: "plano"}.nome == "teste"
    end

    test "cadastar assinante" do
      assert Assinante.cadastrar("carlos", "123", "123") ==
               {:ok, "Assinante carlos cadastrado com sucesso!"}
    end

    test "Retornarr error dizendo que o assinante já está cadastrado" do
      assert Assinante.cadastrar("carlos", "123", "123")

      assert Assinante.cadastrar("carlos", "123", "123") ==
               {:error, "Assinante carlos já cadastrado"}
    end
  end

  describe "testes responsaveis pela busca de assinates" do
    test "buscar pospagos" do
      Assinante.cadastrar("carlos", "123", "123", :pospago)

      assert Assinante.buscar_assinantes("123", :pospago).nome == "carlos"
    end

    test "buscar prepagos" do
      Assinante.cadastrar("bruce", "123", "123")

      assert Assinante.buscar_assinantes("123", :prepago).nome == "bruce"
    end
  end
  describe "delete" do
    test "deleta o assinante" do
      Assinante.cadastrar("Bruce", "123", "1231")
      Assinante.cadastrar("Alvin", "345", "1234")

     assert Assinante.deletar("123") == {:ok, "Assinante Bruce deletado!"}
    end
  end
end
