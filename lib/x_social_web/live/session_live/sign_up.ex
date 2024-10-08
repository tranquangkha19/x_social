defmodule XSocialWeb.SessionLive.SignUp do
  use XSocialWeb, :live_view

  def render(assigns) do
    ~H"""
    <section>
      <div class="flex flex-col items-center justify-center px-6 py-8 mx-auto md:h-screen lg:py-0">
        <a href="#" class="flex items-center mb-6 text-2xl font-semibold text-gray-900">
          XSocial
        </a>
        <div class="w-full bg-white rounded-lg shadow dark:border md:mt-0 sm:max-w-md xl:p-0">
          <div class="p-6 space-y-4 md:space-y-6 sm:p-8">
            <h1 class="text-xl font-bold leading-tight tracking-tight text-gray-900 md:text-2xl ">
              Create and account
            </h1>
            <form class="space-y-4 md:space-y-6" phx-submit="register">
              <div>
                <label for="username" class="block mb-2 text-sm font-medium text-gray-900 ">
                  Username
                </label>
                <input
                  type="username"
                  name="username"
                  id="username"
                  class="bg-gray-50 border border-gray-300 text-gray-900 sm:text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 dark:focus:ring-blue-500 dark:focus:border-blue-500"
                  required=""
                />
              </div>
              <div>
                <label for="password" class="block mb-2 text-sm font-medium text-gray-900 ">
                  Password
                </label>
                <input
                  type="password"
                  name="password"
                  id="password"
                  placeholder="••••••••"
                  class="bg-gray-50 border border-gray-300 text-gray-900 sm:text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 dark:focus:ring-blue-500 dark:focus:border-blue-500"
                  required=""
                />
              </div>
              <div>
                <label for="confirm-password" class="block mb-2 text-sm font-medium text-gray-900 ">
                  Confirm password
                </label>
                <input
                  type="password"
                  name="confirm-password"
                  id="confirm-password"
                  placeholder="••••••••"
                  class="bg-gray-50 border border-gray-300 text-gray-900 sm:text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 dark:focus:ring-blue-500 dark:focus:border-blue-500"
                  required=""
                />
              </div>

              <button
                type="submit"
                class="w-full bg-primary-600 hover:bg-primary-700 focus:ring-4 focus:outline-none focus:ring-primary-300 rounded-lg text-medium px-5 py-2.5 text-center dark:bg-primary-600 dark:hover:bg-primary-700 dark:focus:ring-primary-800 bg-indigo-400 font-bold"
              >
                Create an account
              </button>
              <p class="text-sm font-light text-gray-500 dark:text-gray-400">
                Already have an account?
                <a
                  href="/login"
                  class="font-medium text-primary-600 hover:underline dark:text-primary-500"
                >
                  Login here
                </a>
              </p>
            </form>
          </div>
        </div>
      </div>
    </section>
    """
  end

  def mount(_params, _session, socket) do
    changeset = XSocial.Auth.change_user(%XSocial.Auth.User{})
    {:ok, assign(socket, changeset: changeset)}
  end

  def handle_event(
        "register",
        %{"username" => username, "password" => password, "confirm-password" => confirm_password},
        socket
      ) do
    with {:match_password, true} <- {:match_password, password == confirm_password},
         {:ok, _user} <- XSocial.Auth.create_user(%{username: username, password: password}) do
      {:noreply, socket |> put_flash(:info, "Registered successfully!") |> redirect(to: "/login")}
    else
      {:match_password, false} ->
        {:noreply, socket |> put_flash(:error, "Password and Confirm password are not match!")}

      {:error, %{errors: _}} ->
        {:noreply, socket |> put_flash(:error, "Password should be at least 6 characters!")}

      {:error, msg} ->
        {:noreply, socket |> put_flash(:error, msg)}
    end
  end
end
