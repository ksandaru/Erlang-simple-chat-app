{application, chat_app,
  [
    {description, "distributed chat application with mnesia."},
    {vsn, "0.1.0"},
    {modules,[
      db_sup
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