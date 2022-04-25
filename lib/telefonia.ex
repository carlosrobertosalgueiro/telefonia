defmodule Telefonia do
  @spec cadastrar_assinate(any, any, any) :: any
  def cadastrar_assinate(nome, numero, cpf) do
    Assinante.cadastrar(nome, numero, cpf)
  end
end
