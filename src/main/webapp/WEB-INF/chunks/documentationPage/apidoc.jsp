<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%> 
<h3>Как происходит игра</h3>
<p>Сервер собирает команды от игроков, участвующих в игре. Раз в две секунды сервер пересчитывает карту с учетом полученных от игроков команд.</p>
<p>Процесс пересчета юнитов в каждой вершине происходит следующим образом:</p>
<ul>
	<li>Вычисляется количество юнитов хозяина планеты, с учетом улетевших с этой планеты и прилетевших на нее юнитов этого игрока.</li>
	<li>Получившееся количество увеличивается по <a href="#regeneration">правилам регенерации</a> юнитов для этой планеты.</li>
	<li>После этого происходит выбор нового хозяина планеты (в случае, если на планету были посланы чьи-то еще юниты). Хозяином планеты становится игрок с наибольшим количеством юнитов. При этом юниты всех остальных игроков уничтожаются, а у победителя остается число юнитов, на которое он превосходил следующего по численности игрока.
	<br />
	<i>Например, если на планете после регенерации было 220 юнитов одного игрока, и еще двое прислали по 100 и 225 юнитов, хозяином планеты станет игрок, приславший 225 юнитов, и на планете останется только 5 юнитов.</i>
	</li>
</ul>

<h3 id="regeneration">Правила регенерации</h3>
<p>На каждом шаге число юнитов на планете увеличивается. Для каждого типа планет задан процент и предел регенерации. При регенерации количество юнитов на планете увеличивается на заданный процент, но не более предельного количества (при этом на планете может находиться сколь угодно много юнитов, но если их число больше предельного количества, регенерация происходить не будет). На данный момент существуют типы планет со следующими параметрами:
<ul>
	<li>тип TYPE_A: процент регенерации - 10%, предел - 100 юнитов</li>
	<li>тип TYPE_B: процент регенерации - 15%, предел - 200 юнитов.</li>
	<li>тип TYPE_C: процент регенерации - 20%, предел - 500 юнитов.</li>
	<li>тип TYPE_D: процент регенерации - 30%, предел - 1000 юнитов.</li>
</ul>

<h3>Как подключить бота к серверу</h3>
<p>Сервер игры слушает порт 10040, приложение подключается к нему через клиентский сокет. Локальный адрес сервера в сети EPAM: 10.20.60.2 Внешний адрес: 176.192.95.4
<br/>
<br/>
<h3>Что и как отправлять на сервер</h3>
<p>Идентификация игроков происходит по уникальному ключу, который присваивается каждому игроку при регистрации и может быть изменен по желанию игрока (при условии, что в этот момент игрок не участвует ни в одной игре). Узнать или изменить свой ключ можно на странице <a href='<c:url value="/profile.html"></c:url>'>"<spring:message code="label.menu.profile" />".</a></p>
<p>Запросы на сервер формируются в xml. Для начала игры нужно получить игровое поле, послав пустой список действий:</p>
<pre class="code">
&lt;?xml version="1.0" encoding="UTF-8" standalone="no"?&gt;
&lt;request&gt;
	&lt;token&gt;abcdefghij1k2l3m4n5o6pqrstuvwxyz&lt;/token&gt;
	&lt;actions&gt;
	&lt;/actions&gt;
&lt;/request&gt;
</pre>

<p>Если пользователь не участвует ни в одной игре или игра уже закончена, сервер сразу пришлет ответ с соответствующей ошибкой, например:</p>
<pre class="code">&lt;?xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot; standalone=&quot;no&quot;?&gt;
&lt;response&gt;
	&lt;planets /&gt;
	&lt;errors&gt;
		&lt;error&gt;User has not join any game&lt;/error&gt;
	&lt;/errors&gt;
&lt;/response&gt;
</pre>

<p>Если игра начата, ответом будет описание игрового поля в следующем виде:</p>

<pre class="code">
&lt;?xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot; standalone=&quot;no&quot;?&gt;
	&lt;response&gt;
		&lt;planets&gt;
			&lt;planet id=&quot;1&quot;&gt;
				&lt;owner/&gt;
				&lt;type&gt;TYPE_A&lt;/type&gt;
				&lt;droids&gt;0&lt;/droids&gt;
				&lt;neighbours&gt;
					&lt;neighbour&gt;2&lt;/neighbour&gt;
					&lt;neighbour&gt;3&lt;/neighbour&gt;
				&lt;/neighbours&gt;
			&lt;/planet&gt;
			&lt;planet id=&quot;2&quot;&gt;
				&lt;owner&gt;bot&lt;/owner&gt;
				&lt;type&gt;TYPE_B&lt;/type&gt;
				&lt;droids&gt;55&lt;/droids&gt;
				&lt;neighbours&gt;
					&lt;neighbour&gt;1&lt;/neighbour&gt;
					&lt;neighbour&gt;3&lt;/neighbour&gt;
					&lt;neighbour&gt;5&lt;/neighbour&gt;
					&lt;neighbour&gt;6&lt;/neighbour&gt;
					&lt;neighbour&gt;7&lt;/neighbour&gt;
				&lt;/neighbours&gt;
			&lt;/planet&gt;

			...

		&lt;/planets&gt;
	&lt;errors/&gt;
&lt;/response&gt;
</pre>

<p>Исходя из этих данных приложение игрока должно сформировать ответ. Ответ содержит список команд для передвижения юнитов, например:</p>

<pre class="code">
&lt;?xml version="1.0" encoding="UTF-8" standalone="no"?&gt;
&lt;request&gt;
	&lt;token&gt;abcdefghijklmnopqrstuvwxy&lt;/token&gt;
	&lt;actions&gt;
		&lt;action&gt;
			&lt;from&gt;15&lt;/from&gt;
			&lt;to&gt;25&lt;/to&gt;
			&lt;unitscount&gt;1200&lt;/unitscount&gt;
		&lt;/action&gt;
		&lt;action&gt;
			&lt;from&gt;15&lt;/from&gt;
			&lt;to&gt;23&lt;/to&gt;
			&lt;unitscount&gt;100&lt;/unitscount&gt;
		&lt;/action&gt;
		&lt;action&gt;
			&lt;from&gt;15&lt;/from&gt;
			&lt;to&gt;21&lt;/to&gt;
			&lt;unitscount&gt;105&lt;/unitscount&gt;
		&lt;/action&gt;
	&lt;/actions&gt;
&lt;/request&gt;
</pre>

<p>Ответы на все ошибочные запросы отсылаются сервером почти сразу. Ответ на корректный запрос отсылается сервером после того, как в игре происходит следующий ход, и содержит описание игрового поля после этого хода.</p>
<p>Важное замечание: если запрос был синтаксически корректен, но некоторые из заданных в нем команд невыполнимы (например, команда переслать юнитов с планеты, не принадлежащей игроку, команда переслать больше юнитов, чем есть на планете и т. п), запрос будет считаться корректным и ответ придет только на следующем шаге. При этом в конце ответа будут добавлены сообщения с обнаруженными ошибками.</p>
<p>После отсылки сообщения сервер закрывает соединение, и все последующие действия потребуют создания новых соединений.</p>

<p>Игра завершается, когда на карте остается только один игрок или количество ходов превышает заданный организатором предел. При достижении предела победителем выбирается игрок с максимальным суммарным количеством юнитов на всех его планетах.<p>

<h3 id="example">Пример бота на Java</h3>
<p>Пример простого бота на Java можно скачать <a href="/downloads/bot.zip">здесь</a>.
<p>Исходный код на <a href="https://git.epam.com/igor_drozdov/it-week14-hardcoded-starmarines-sample-bot">git.epam.com</a> </p>
