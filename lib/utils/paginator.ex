defmodule Utils.Paginator do
  @moduledoc """
  Utils.Paginator
  """
  import Ecto.Query, only: [from: 2]

  @default_values %{page: 1, size: 20}
  def default_values, do: @default_values

  @default_types %{
    page: :integer,
    size: :integer
  }
  def default_types, do: @default_types

  defstruct Map.to_list(@default_values)

  def __changeset__, do: @default_types

  def validate(changeset) do
    changeset
    |> Ecto.Changeset.validate_number(:page, greater_than_or_equal_to: 1)
    |> Ecto.Changeset.validate_number(:size, greater_than_or_equal_to: 1)
  end

  def changeset(model, params \\ %{}) do
    model
    |> Ecto.Changeset.cast(params, Map.keys(@default_values))
    |> validate()
  end

  def cast(params \\ %{}) do
    changeset(%__MODULE__{}, params) |> validate()
  end

  def new(query, repo, params) do
    changesetz = changeset(%__MODULE__{}, params)

    with {:ok, data} <- check_and_apply_changes(changesetz) do
      total_entries = repo.aggregate(query, :count, :id)
      offset = data.size * (data.page - 1)
      entries = from(i in query, limit: ^data.size, offset: ^offset) |> repo.all()

      %{
        entries: entries,
        page: data.page,
        size: data.size,
        total_entries: total_entries,
        total_pages: Float.ceil(total_entries / data.size) |> round()
      }
    end
  end

  defp check_and_apply_changes(form_changesets) when is_list(form_changesets) do
    Enum.reduce(form_changesets, {:ok, []}, fn
      form_changeset, {:ok, data} ->
        if form_changeset.valid? do
          changes = form_changeset |> Ecto.Changeset.apply_changes()
          {:ok, [changes | data]}
        else
          {:error, :validation_failed, form_changeset}
        end

      _form_changeset, acc ->
        acc
    end)
  end

  defp check_and_apply_changes(form_changeset) do
    if form_changeset.valid? do
      changes = form_changeset |> Ecto.Changeset.apply_changes()

      {:ok, changes}
    else
      {:error, :validation_failed, form_changeset}
    end
  end
end
