SELECT * FROM Jogadores

SELECT * FROM Equipas
SELECT * FROM Competicoes

SELECT * FROM Jogadores WHERE Jogadores.Nome LIKE '%Jota%Silva%'
SELECT * FROM JogadoresAvaliacao WHERE JogadoresAvaliacao.JogadorID = 663244

SELECT * FROM AAA_Jogadores
SELECT * FROM AAA_FichasJogo

SELECT * FROM AAA_Equipas

SELECT JogadoresAvaliacao.JogadorID, JogadoresAvaliacao.DataAvaliacao, Equipas.Nome Equipa, JogadoresAvaliacao.Valor, Paises.Descr Pais 
INTO AAA_JogadoresAvaliacao
FROM JogadoresAvaliacao, Equipas, Jogadores, Paises
WHERE JogadoresAvaliacao.EquipaID = Equipas.ID AND JogadoresAvaliacao.JogadorID = Jogadores.ID AND Jogadores.PaisID = Paises.ID

SELECT Jogadores.ID, Jogadores.Nome, Jogadores.Epoca, Jogadores.EquipaID, Equipas.Nome Equipa, Paises.Descr Pais, Jogadores.DataNasc, Jogadores.MaiorValor, Jogadores.ValorAtual, Jogadores.DataContrato, PosicoesJogador.Descr PosicoesJogador
INTO AAA_Jogadores
FROM Jogadores, Equipas, Paises, PosicoesJogador
WHERE Jogadores.EquipaID = Equipas.ID AND Jogadores.PaisID = Paises.ID AND Jogadores.PosicaoJogadorID = PosicoesJogador.ID

SELECT Equipas.ID, Equipas.Nome, Equipas.CompeticaoIntID, Estadios.Nome Estadio, Equipas.SaldoMercadoTransf 
INTO AAA_Equipas
FROM Equipas, Estadios
WHERE Estadios.ID = Equipas.EstadioID


SELECT Competicoes.ID, Competicoes.Nome, Paises.Descr Pais, Competicoes.Sigla, TipoCompeticao.Descr TipoCompeticao
INTO AAA_Competicoes
FROM Competicoes, TipoCompeticao, Paises
WHERE Competicoes.TipoCompID = TipoCompeticao.ID AND Competicoes.PaisID = Paises.ID

SELECT * FROM Jogos

SELECT Jogos.ID, Jogos.CompeticaoID, Competicoes.Nome Competicao, Jogos.Epoca, Jogos.Data, RondaJogo.Descr Ronda, Jogos.EquipaCasaID, Casa.Nome EquipaCasa, Jogos.EquipaForaID, Fora.Nome EquipaFora, TCasa.Nome TreinadorCasa, TFora.Nome TreinadorFora, Estadios.Nome Estadio, Arbitros.Nome Arbitro, Jogos.Assistencia 
INTO AAA_Jogos
FROM Jogos, Competicoes, RondaJogo, Equipas Casa, Equipas Fora, Treinadores TCasa, Treinadores TFora, Estadios, Arbitros
WHERE Competicoes.ID = Jogos.CompeticaoID AND Jogos.RondaID = RondaJogo.ID AND Casa.ID = Jogos.EquipaCasaID AND Fora.ID = Jogos.EquipaForaID
AND TCasa.ID = Jogos.TreinadorCasaID AND TFora.ID = Jogos.TreinadorForaID AND Jogos.EstadioID = Estadios.ID AND Jogos.ArbitroID = Arbitros.ID

SELECT FichasJogo.JogoID, FichasJogo.JogadorID, Jogadores.Nome Jogador, FichasJogo.EquipaID, Equipas.Nome Equipa, FichasJogo.Amarelos, FichasJogo.Vermelho, FichasJogo.Golos, FichasJogo.Assistencias, FichasJogo.Minutos
--INTO AAA_FichasJogo
FROM FichasJogo, Jogadores, Equipas, Jogos
WHERE FichasJogo.JogadorID = Jogadores.ID AND FichasJogo.EquipaID = Equipas.ID AND FichasJogo.JogoID = Jogos.ID AND Jogos.Epoca >= 2020

SELECT * FROM EventosJogo

SELECT Equipas.ID, EventosJogo.JogoID, EventosJogo.Minuto, TipoEventoJogo.Descr TipoEventoJogo, EventosJogo.JogadorID, EventosJogo.EquipaID, Equipas.Nome, EventosJogo.ObsEvento, EventosJogo.JogadorInID, EventosJogo.JogadorAssitID 
INTO AAA_EventosJogo 
FROM EventosJogo, Jogadores, TipoEventoJogo, Equipas, Jogos
WHERE EventosJogo.JogadorID = Jogadores.ID AND EventosJogo.TipoEventoID = TipoEventoJogo.ID AND EventosJogo.EquipaID = Equipas.ID
AND EventosJogo.JogoID = Jogos.ID AND Jogos.Epoca >= 2020


SELECT * FROM AAA_Jogadores WHERE AAA_Jogadores.Nome LIKE '%DU-RI%'

SELECT * FROM AAA_FichasJogo WHERE AAA_Jogadores.Nome LIKE 'Cristiano Ronaldo'
WITH TopJogador
AS
(	SELECT TOP 100 ID, Nome, ValorAtual
	FROM Jogadores 
	WHERE ValorAtual IS NOT NULL 
	--and Nome like '%LAVIA%'
	ORDER BY ValorAtual DESC
)
SELECT TOP 20 FichasJogo.JogadorID, Jogadores.Nome, Equipas.Nome, CAST(TopJogador.ValorAtual / 1000000 AS VARCHAR(5)) + 'M', COUNT(DISTINCT JogoID) NrJogos 
FROM Jogadores, FichasJogo, Jogos, Equipas, TopJogador
WHERE Jogadores.ID = FichasJogo.JogadorID AND Jogadores.EquipaID = Equipas.ID AND TopJogador.ID = FichasJogo.JogadorID 
--and TopJogador.Nome like '%LAVIA%'
AND JogoID = Jogos.ID AND DATEDIFF(YEAR, Data, GETDATE()) <= 3
GROUP BY FichasJogo.JogadorID, Jogadores.Nome, Equipas.Nome, TopJogador.ValorAtual
ORDER BY NrJogos

SELECT * FROM AAA_Competicoes
