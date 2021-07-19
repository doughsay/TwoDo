# TwoDo - A simple ToDo App in Phoenix LiveView

Keep track of multiple lists of tasks in a simple responsive UI.

## Setup

It is assumed you have postgres installed locally, and that it is accessible
with he username and password `postgres:postgres`. If not, please modify
`config/dev.exs` to match your settings.

The tool versions used during development are noted in `.tool-version`. It may
work with other versions, but these are known to work.

To start the server:

-   Install dependencies with `mix deps.get`
-   Create and migrate your database with `mix ecto.setup`
-   Install Node.js dependencies with `npm install` inside the `assets` directory
-   Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Usage

There are a few keyboard shortcuts implemented for the tasks view:

-   `n` - Create a new task
-   `.` & `,` - Select next/previous task
-   `Enter` or `e` - Edit selected task
-   `Space` or `x` - Toggle selected task as `done` or `new`
-   `Backspace` - Return to list view
