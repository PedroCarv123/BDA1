SELECT * FROM Jogadores

SELECT * FROM Equipas
SELECT * FROM Competicoes

SELECT * FROM AAA_Jogadores
SELECT * FROM AAA_Equipas

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
