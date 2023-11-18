--1 Calcular a idade média de jogadores das várias ligas nacionais
SELECT Descr Pais, Competicoes.Nome, AVG(convert(int,DATEDIFF(d, DataNasc, getdate())/365.25)) Idade_Media
FROM Competicoes, Equipas, Jogadores, Paises
WHERE Competicoes.ID = CompeticaoIntID  AND EquipaID = Equipas.ID AND TipoCompID = 6 AND Competicoes.PaisID = Paises.ID
GROUP BY Descr, Competicoes.Nome
ORDER BY Idade_Media

--2 dos 100 Jogadores com maior valor de mercado qual tem menos jogos nos últimos 2 anos
WITH TopJogador
AS
(	SELECT TOP 100 ID, ValorAtual
	FROM Jogadores 
	WHERE ValorAtual IS NOT NULL 
	ORDER BY ValorAtual DESC
)
SELECT TOP 1 FichasJogo.JogadorID, Jogadores.Nome, Equipas.Nome, COUNT(DISTINCT JogoID) NrJogos 
FROM Jogadores, FichasJogo, Jogos, Equipas, TopJogador
WHERE Jogadores.ID = FichasJogo.JogadorID AND Jogadores.EquipaID = Equipas.ID AND TopJogador.ID = FichasJogo.JogadorID 
AND JogoID = Jogos.ID AND DATEDIFF(YEAR, Data, GETDATE()) <= 2
GROUP BY FichasJogo.JogadorID, Jogadores.Nome, Equipas.Nome
ORDER BY NrJogos

--3 nr medio de golos marcado por tipo de competicao (campeonatos) (desde a epoca 2020/2021)
SELECT Epoca, Nome, TipoCompeticao.Descr, Paises.Descr, (SUM(Golos) / COUNT(DISTINCT JogoID)) MediaGolos
FROM Jogos, FichasJogo, Competicoes, TipoCompeticao, Paises
WHERE Jogos.ID = JogoID AND CompeticaoID = Competicoes.ID AND TipoCompID = TipoCompeticao.ID
AND Epoca >= 2020 AND Paises.ID = PaisID AND TipoCompID = 6
GROUP BY Epoca, Nome, TipoCompeticao.Descr, Paises.Descr
ORDER BY MediaGolos DESC

--4 qual o arbitro (com pelos menos 10 jogos) que mostrou mais cartoes vermelhos na liga europa
SELECT Arbitros.Nome, COUNT(DISTINCT JogoID) NrJogos, SUM(CAST(Vermelho AS INT)) NrVermelhos
FROM Jogos, FichasJogo, Competicoes, TipoCompeticao, Arbitros 
WHERE Descr = 'europa_league' AND TipoCompID = TipoCompeticao.ID AND Competicoes.ID = CompeticaoID
AND JogoID = Jogos.ID AND ArbitroID = Arbitros.ID
GROUP BY Arbitros.Nome
HAVING COUNT(DISTINCT JogoID) >= 10
ORDER BY NrVermelhos DESC

--5 qual o top 3 de jogadores com mais golos na champions (mas que nunca jogaram o qualifying da champions)
SELECT Jogadores.Nome, COUNT(DISTINCT JogoID) NrJogos, SUM(Golos) NrGolos, COUNT(DISTINCT Jogos.Epoca) NrEpocas
FROM Jogos, FichasJogo, Competicoes, TipoCompeticao, Jogadores  
WHERE Descr = 'uefa_champions_league' AND TipoCompID = TipoCompeticao.ID AND Competicoes.ID = CompeticaoID
AND JogoID = Jogos.ID AND JogadorID = Jogadores.ID
AND JogadorID NOT IN(
SELECT DISTINCT JogadorID  
FROM Jogos, FichasJogo, Competicoes, TipoCompeticao, Jogadores  
WHERE Descr = 'uefa_champions_league_qualifying' AND TipoCompID = TipoCompeticao.ID AND Competicoes.ID = CompeticaoID
AND JogoID = Jogos.ID AND JogadorID = Jogadores.ID)
GROUP BY Jogadores.Nome
ORDER BY NrGolos DESC

--6 Qual o jogador que a entrar como substituto tem melhor media de golos por epoca 
SELECT Jogos.Epoca, JogadorInID, Jogadores.Nome, Equipas.Nome, SUM(Golos) NrGolos  
FROM Jogos, EventosJogo, TipoEventoJogo, FichasJogo, Jogadores, Equipas
WHERE Descr = 'Substitutions' AND TipoEventoID = TipoEventoJogo.ID AND Jogos.ID = EventosJogo.JogoID AND EventosJogo.JogoID = FichasJogo.JogoID
AND FichasJogo.JogadorID = JogadorInID AND Golos > 0 AND EventosJogo.JogadorID = Jogadores.ID AND Equipas.ID = FichasJogo.EquipaID
GROUP BY Jogos.Epoca, JogadorInID, Jogadores.Nome, Equipas.Nome
ORDER BY NrGolos DESC

--7 Qual o defesa maior media de amarelos (em epocas em que nunca foi substituido) nas taças internas

--8 Qual o estadio em que a equipa da casa perde mais jogos e tem maior taxa de ocupaçao

--9 Qual o treinador que ganha mais jogos fora (tendo treinado pelo menos 2 equipas num país onde trabalhou)

--10 Quais as competicoes onde a media de substituições por jogo é menor 

--11 Qual o jogador mais vezes substituido (em 2022/2023) com melhor avaliação antes do primeiro jogo que fez na epoca 2023/2024

SELECT Jogos.Epoca, JogadorInID, Jogadores.Nome, Equipas.Nome, SUM(Golos) NrGolos  
FROM Jogos, EventosJogo, TipoEventoJogo, FichasJogo, Jogadores, Equipas
WHERE Descr = 'Substitutions' AND TipoEventoID = TipoEventoJogo.ID AND Jogos.ID = EventosJogo.JogoID AND EventosJogo.JogoID = FichasJogo.JogoID
AND FichasJogo.JogadorID = JogadorInID AND Golos > 0 AND EventosJogo.JogadorID = Jogadores.ID AND Equipas.ID = FichasJogo.EquipaID
GROUP BY Jogos.Epoca, JogadorInID, Jogadores.Nome, Equipas.Nome
ORDER BY NrGolos DESC


SELECT * FROM PosicoesJogador
SELECT * FROM EventosJogo WHERE TipoEventoID = 3
SELECT * FROM TipoEventoJogo
SELECT * FROM TipoCompeticao
SELECT * FROM Competicoes WHERE PaisID=61

SELECT * FROM Competicoes WHERE TipoCompID = 9
SELECT DISTINCT CompeticaoID FROM Jogos WHERE CompeticaoID = 39


SELECT FichasJogo.JogadorID, Jogadores.Nome, Equipas.Nome, COUNT(DISTINCT JogoID) NrJogos 
FROM Jogadores, FichasJogo, Jogos, Equipas 
WHERE Jogadores.ID = FichasJogo.JogadorID AND Jogadores.EquipaID = Equipas.ID 
AND JogoID = Jogos.ID AND DATEDIFF(YEAR, Data, GETDATE()) <= 2
GROUP BY FichasJogo.JogadorID, Jogadores.Nome, Equipas.Nome
ORDER BY NrJogos DESC

SELECT * FROM FichasJogo WHERE JogadorID = 448470
SELECT * FROM Jogadores WHERE Nome LIKE '%ANDr%franco%'
SELECT * FROM TP1_BD1_Original.dbo.Appearances WHERE game_id = 3956690
SELECT * FROM TP1_BD1_Original.dbo.Games WHERE game_id = 3956690
SELECT * FROM TP1_BD1_Original.dbo.Clubs WHERE club_id IN (46,720)


SELECT * 
FROM Jogadores, FichasJogo, Equipas
WHERE Jogadores.ID = JogadorID AND FichasJogo.EquipaID = Equipas.ID
AND EXISTS(
SELECT TOP 1 JogadorID, COUNT(DISTINCT FichasJogo.EquipaID) NrEquipas 
FROM FichasJogo A
WHERE A.JogadorID = Jogadores.ID)



SELECT * FROM FichasJogo WHERE JogadorID = 197545

SELECT * FROM Equipas WHERE Nome = 'BAYER 04 LEVERKUSEN'
SELECT * FROM Competicoes WHERE Nome = 'BAYER 04 LEVERKUSEN'
SELECT * FROM Jogadores WHERE Nome = 'KAUÃ SANTOS'

SELECT * FROM TipoCompeticao
