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
end
