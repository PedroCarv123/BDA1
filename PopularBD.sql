--Popular tabela "Paises"
INSERT INTO TP1_BD1.dbo.Paises (Descr)
SELECT DISTINCT Country_name FROM Competitions WHERE country_name IS NOT NULL
UNION
SELECT DISTINCT country_of_citizenship FROM Players WHERE country_of_citizenship IS NOT NULL

--Popular tabela "TipoCompeticao"
INSERT INTO TP1_BD1.dbo.TipoCompeticao (Descr)
SELECT DISTINCT sub_type FROM Competitions

--Popular tabela "Estadios" (clubes a mencionar o mesmo estadio com diferente capacidade - Génova)
INSERT INTO TP1_BD1.dbo.Estadios (Nome, Capacidade)
SELECT UPPER(stadium_name), MAX(stadium_seats) Lugares FROM Clubs GROUP BY stadium_name

INSERT INTO TP1_BD1.dbo.Estadios (Nome, Capacidade)
SELECT UPPER(stadium), MAX(ISNULL(attendance,0)) Lugares FROM Games 
WHERE stadium IS NOT NULL AND NOT EXISTS (SELECT * FROM TP1_BD1.dbo.Estadios WHERE nome = stadium) 
GROUP BY stadium

--Popular tabela "Treinador"
INSERT INTO TP1_BD1.dbo.Treinadores (Nome)
SELECT DISTINCT home_club_manager_name Treinador FROM Games WHERE home_club_manager_name IS NOT NULL
UNION 
SELECT DISTINCT away_club_manager_name Treinador FROM Games WHERE away_club_manager_name IS NOT NULL

--Popular tabela "Arbitros"
INSERT INTO TP1_BD1.dbo.Arbitros (Nome)
SELECT DISTINCT referee FROM Games WHERE referee IS NOT NULL

--Popular tabela "RondaJogo"
INSERT INTO TP1_BD1.dbo.RondaJogo (Descr)
SELECT DISTINCT round FROM Games WHERE round IS NOT NULL

--Popular tabela "PosicoesJogador"
INSERT INTO TP1_BD1.dbo.PosicoesJogador (Descr)
SELECT DISTINCT sub_position FROM Players WHERE sub_position IS NOT NULL

--Popular tabela "TipoEventoJogo"
INSERT INTO TP1_BD1.dbo.TipoEventoJogo (Descr)
SELECT DISTINCT type FROM GameEvents WHERE type IS NOT NULL

--Popular tabela "Competicao"
INSERT INTO TP1_BD1.dbo.Competicoes (Nome, TipoCompID, PaisID, Sigla)
SELECT DISTINCT UPPER(name), TipoCompeticao.ID, Paises.ID, competition_id 
FROM TP1_BD1.dbo.TipoCompeticao, Competitions
LEFT JOIN TP1_BD1.dbo.Paises ON country_name = Paises.Descr 
WHERE TipoCompeticao.Descr = sub_type 

--Popular tabela "Equipas"
INSERT INTO TP1_BD1.dbo.Equipas (ID, Nome, CompeticaoIntID, EstadioID, SaldoMercadoTransf)
SELECT DISTINCT club_id, UPPER(Clubs.name), Competicoes.ID, Estadios.ID, net_transfer_record
FROM Clubs, Competitions, TP1_BD1.dbo.Competicoes, TP1_BD1.dbo.Estadios
WHERE domestic_competition_id = competition_id AND Competitions.competition_id = Sigla AND Estadios.Nome = stadium_name 


--Popular tabela "Jogadores"
INSERT INTO TP1_BD1.dbo.Jogadores (ID, Nome, Epoca, EquipaID, PaisID, DataNasc, MaiorValor, ValorAtual, DataContrato, PosicaoJogadorID)
SELECT player_id, UPPER(Players.name), Players.last_season, Equipas.ID, Paises.ID, date_of_birth, highest_market_value_in_eur, market_value_in_eur, contract_expiration_date, PosicoesJogador.ID 
FROM Players
LEFT JOIN Clubs ON club_id = current_club_id
LEFT JOIN TP1_BD1.dbo.Equipas ON Clubs.club_id = Equipas.ID
LEFT JOIN TP1_BD1.dbo.Paises ON Paises.Descr = country_of_citizenship 
LEFT JOIN TP1_BD1.dbo.PosicoesJogador ON PosicoesJogador.Descr = sub_position

--Popular tabela "JogadoresAvaliacao" (há ID jogador com avaliação que nao exista na tabela Jogadores)
INSERT INTO TP1_BD1.dbo.JogadoresAvaliacao (JogadorID, DataAvaliacao, EquipaID, Valor)
SELECT Jogadores.ID, datetime, Equipas.ID, PlayersValue.market_value_in_eur
FROM PlayersValue 
LEFT JOIN Players ON Players.player_id = PlayersValue.player_id
LEFT JOIN TP1_BD1.dbo.Equipas ON Players.current_club_id = Equipas.ID
LEFT JOIN TP1_BD1.dbo.Jogadores ON Jogadores.ID = Players.player_id
WHERE Jogadores.ID IS NOT NULL

--Popular tabela "Jogos" (existem jogos cujos equipas não estao na tabela) 
INSERT INTO TP1_BD1.dbo.Jogos (ID, CompeticaoID, Epoca, RondaID, Data, EquipaCasaID, EquipaForaID, TreinadorCasaID, TreinadorForaID, EstadioID, Assistencia, ArbitroID)
SELECT game_id, Competicoes.ID, season, RondaJogo.ID, date, Casa.ID, Fora.ID, TCasa.ID, TFora.ID, Estadios.ID, ISNULL(attendance,0) Assist, Arbitros.ID
FROM Games
LEFT JOIN TP1_BD1.dbo.Competicoes ON competition_id = sigla
LEFT JOIN TP1_BD1.dbo.RondaJogo ON round = RondaJogo.Descr
LEFT JOIN TP1_BD1.dbo.Equipas Casa ON home_club_id = Casa.ID
LEFT JOIN TP1_BD1.dbo.Equipas Fora ON away_club_id = Fora.ID
LEFT JOIN TP1_BD1.dbo.Treinadores TCasa ON home_club_manager_name = TCasa.Nome
LEFT JOIN TP1_BD1.dbo.Treinadores TFora ON away_club_manager_name = TFora.Nome
LEFT JOIN TP1_BD1.dbo.Estadios ON stadium = Estadios.Nome
LEFT JOIN TP1_BD1.dbo.Arbitros ON referee = Arbitros.Nome
WHERE Casa.ID IS NOT NULL AND Fora.ID IS NOT NULL 


--Popular tabela "Alinhamentos" (preencher somente para os jogos existentes)
INSERT INTO TP1_BD1.dbo.Alinhamentos (JogoID, JogadorID, EquipaID, OnzeInicial, Numero, Capitao)
SELECT Lineups.game_id, Lineups.player_id, Lineups.club_id, 
CASE
    WHEN type = 'starting_lineup' THEN 1
    ELSE 0
END OnzeInicial, number, team_captain  
FROM Lineups 
INNER JOIN Games ON Games.game_id = Lineups.game_id
INNER JOIN TP1_BD1.dbo.Jogos ON Jogos.ID = Lineups.game_id
INNER JOIN Players ON Players.player_id = Lineups.player_id
INNER JOIN Clubs ON Clubs.club_id = Lineups.club_id

--Popular tabela "FichasJogo" (preencher somente para os jogos existentes)
INSERT INTO TP1_BD1.dbo.FichasJogo (JogoID, JogadorID, EquipaID, Amarelos, Vermelho, Golos, Assistencias, Minutos)
SELECT Appearances.game_id, Appearances.player_id, player_club_id, yellow_cards, red_cards, goals, assists, minutes_played 
FROM Appearances 
INNER JOIN Games ON Games.game_id = Appearances.game_id
INNER JOIN TP1_BD1.dbo.Jogos ON Jogos.ID = Appearances.game_id
INNER JOIN Players ON Players.player_id = Appearances.player_id
INNER JOIN Clubs ON Clubs.club_id = Appearances.player_club_id

--Popular tabela "EventosJogo" (preencher somente para os jogos existentes)
INSERT INTO TP1_BD1.dbo.EventosJogo (JogoID, Minuto, TipoEventoID, JogadorID, EquipaID, ObsEvento, JogadorInID, JogadorAssitID)
SELECT game_id, minute, TipoEventoJogo.ID, player_id, club_id, description, player_in_id, player_assist_id 
FROM GameEvents
INNER JOIN TP1_BD1.dbo.TipoEventoJogo ON TipoEventoJogo.Descr = type
INNER JOIN TP1_BD1.dbo.Jogos ON Jogos.ID = GameEvents.game_id
INNER JOIN TP1_BD1.dbo.Jogadores ON Jogadores.ID = GameEvents.player_id
LEFT JOIN TP1_BD1.dbo.Jogadores JogIN ON JogIN.ID = GameEvents.player_in_id
LEFT JOIN TP1_BD1.dbo.Jogadores JogAssist ON JogAssist.ID = GameEvents.player_assist_id
WHERE (GameEvents.player_in_id IS NULL OR JogIN.ID IS NOT NULL) AND (GameEvents.player_assist_id IS NULL OR JogAssist.ID IS NOT NULL)
