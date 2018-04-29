
# EmoMessages
_Эмулятор отправки полученных по api сообщений в мессенеджеры._

В качестве хранилища для организации очередей Я выбрал [redis](https://redis.io/) и gem [sidekiq](https://github.com/mperham/sidekiq), т.к. они хорошо документированы и имеют высокопроизводительные. Также они имеют активное комьюнити, благодаря чему в случае какой-либо проблемы, можно быстро найти ее решение. Расписание настраивается в config/initializers/scheduler.rb, для которого Я использовал гем [rufus-scheduler](https://github.com/jmettraux/rufus-scheduler).

#### Для запуска необходимы:
- Postgresql 9+
- Redis 4.0+
- Rails 5.1+
- Ruby 2.4+

#### Для старта:
- rake db:setup
- rake db:seed
- rails s
- bundle exec sidekiq

#### API:
__Регистрация сообщения:__ _POST /registerMessage_
params:
>token: ZZUUy9KY3xX6i2jvh5zKGVh9
>message:Hello world!
>telegram:@cosmos404
>whats_up[]:123456789
>whats_up[]:987654321

answer:
> registered_messages[]

__Получение статистики получателя:__ _GET /recipientStats_
params:
>token:ZZUUy9KY3xX6i2jvh5zKGVh9
 >telegram:@cosmos404

answer:
> recipient: @cosmos404,
>attempts_count: 1,
>messages_count: 1,
 >failure_rate: 0.0
