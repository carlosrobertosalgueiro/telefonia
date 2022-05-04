defmodule ChamadaTest do
  use ExUnit.Case

  describe "Estrutura da chamda" do
    test "Testando estrutura da chamada" do
      assert %Chamada{data: "teste_data", duracao: "3 minutos"}.duracao == "3 minutos"
    end
  end
end
