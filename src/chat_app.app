{application, chat_app,
  [
    {description, "distributed chat application with mnesia."},
    {vsn, "0.1.0"},
    {modules,[
      db_sup,
      chat_sup,
      chat_client,
      database_logic,
      database_server,
      chat_fsm,
      chat_app
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