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
                <label for="email" class="block mb-2 text-sm font-medium text-gray-900 ">
                  Your email
                </label>
                <input
                  type="email"
                  name="email"
                  id="email"
                  class="bg-gray-50 border border-gray-300 text-gray-900 sm:text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 dark:focus:ring-blue-500 dark:focus:border-blue-500"
                  placeholder="name@company.com"
                  required=""
                />
                <%= for {msg, _} <- Keyword.get(@changeset.errors, :email, []),
                        do: "<div class=\"error-message\">#{msg}</div>" %>
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
                <%= for {msg, _} <- Keyword.get(@changeset.errors, :password, []),
                        do: "<div class=\"error-message\">#{msg}</div>" %>
              </div>
              <div>
                <label for="confirm-password" class="block mb-2 text-sm font-medium text-gray-900 ">
                  Confirm password
                </label>
                <input
                  type="confirm-password"
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

  def handle_event("register", %{"email" => email, "password" => password}, socket) do
    IO.inspect("hahahahah")

    case XSocial.Auth.create_user(%{email: email, username: email, password: password}) do
      {:ok, _user} ->
        IO.inspect("successsssss")

        {:noreply,
         socket |> put_flash(:info, "Registered successfully!") |> redirect(to: "/login")}

      {:error, changeset} ->
        IO.inspect("failllllllllllll")
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
