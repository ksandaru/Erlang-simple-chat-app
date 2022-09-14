{application, chat_app,
  [
    {description, "my chat app."},
    {vsn, "0.1.0"},
    {modules,[
      message_server,
      chat_sup,
      database_logic,
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