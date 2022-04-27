defmodule Assinante do
  @moduledoc """
  Modulo de assinante para cadastros de tipos de assinantes como `prepago`e `pospago`

  A mais ultilizada é a função `cadastrar/4`
  """

  defstruct nome: nil, numero: nil, cpf: nil, plano: nil

  @assinantes %{:prepago => "pre.txt", :pospago => "pos.txt"}

  def buscar_assinantes(numero, key \\ :all), do: buscar(numero, key)
  defp buscar(numero, :prepago), do: filtro(assinantes_prepago(), numero)
  defp buscar(numero, :pospago), do: filtro(assinantes_pospago(), numero)
  defp buscar(numero, :all), do: filtro(assinantes(), numero)
  defp filtro(lista, numero), do: Enum.find(lista, &(&1.numero == numero))

  def assinantes, do: read(:prepago) ++ read(:pospago)
  def assinantes_prepago, do: read(:prepago)
  def assinantes_pospago, do: read(:pospago)

  def cadastrar(nome, numero, cpf, plano \\ :prepago) do
    case buscar_assinantes(numero) do
      nil ->
        (read(plano) ++ [%__MODULE__{nome: nome, numero: numero, cpf: cpf, plano: plano}])
        |> :erlang.term_to_binary()
        |> write(plano)

        {:ok, "Assinante #{nome} cadastrado com sucesso!"}

      _assinate ->
        {:error, "Assinante #{nome} já cadastrado"}
    end
  end

  defp write(lista_assinantes, plano), do: File.write(@assinantes[plano], lista_assinantes)

  def read(plano) do
    case File.read(@assinantes[plano]) do
      {:ok, assinantes} ->
        assinantes
        |> :erlang.binary_to_term()

      {:error, :ennoent} ->
        {:error, "arquivo invalido"}
    end
  end
end
