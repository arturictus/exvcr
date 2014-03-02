defmodule ExVCR.Checker do
  @moduledoc """
  Provides data store for checking which cassette files are used.
  It's for [mix vcr.check] task.
  """

  use ExActor.GenServer, export: :singleton

  defcall get, state: state, do: reply(state)
  defcast set(x), do: new_state(x)
  defcast append(x), state: state, do: new_state(state.files([x|state.files]))

  def add_cache_count(recorder),  do: add_count(recorder, :cache)
  def add_server_count(recorder), do: add_count(recorder, :server)

  defp add_count(recorder, type) do
    if Mix.Project.config[:test_coverage][:tool] == ExVCR do
      ExVCR.Checker.append({type, ExVCR.Recorder.get_file_path(recorder)})
    end
  end
end