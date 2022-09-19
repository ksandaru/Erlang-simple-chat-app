{application, chat_app,
  [
    {description, "distributed chat application with mnesia."},
    {vsn, "0.1.0"},
    {modules,[
      database_server
    ]},
    {applications, [
      kernel,
      stdlib,
      mnesia
    ]},
    {mod, {chat_app, []}},
    {env, []}
  ]
}.