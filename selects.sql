-- 1. Usu�rios que geraram SOS pr�ximos a sensores com alertas cr�ticos
-- Mostra o nome do usu�rio, tipo e a quantidade de alertas cr�ticos pr�ximos aos seus pedidos de SOS

SELECT 
    u.nome AS nome_usuario,
    u.tipo_usuario,
    COUNT(a.id) AS total_alertas_criticos
FROM usuarios u
JOIN sos s ON s.usuario_id = u.id
JOIN sensores se ON ROUND(se.latitude, 1) = ROUND(s.latitude, 1) AND ROUND(se.longitude, 1) = ROUND(s.longitude, 1)
JOIN alertas a ON a.sensor_id = se.id AND a.nivel = 'critico'
GROUP BY u.nome, u.tipo_usuario
HAVING COUNT(a.id) > 0
ORDER BY total_alertas_criticos DESC;

-- 2. Sensores com mais pedidos de SOS e alertas registrados
-- Exibe a localiza��o dos sensores, quantidade de SOS pr�ximos e alertas associados

SELECT 
    se.localizacao,
    COUNT(DISTINCT s.id) AS total_sos,
    COUNT(DISTINCT a.id) AS total_alertas
FROM sensores se
JOIN alertas a ON a.sensor_id = se.id
JOIN sos s ON ROUND(s.latitude, 1) = ROUND(se.latitude, 1) AND ROUND(s.longitude, 1) = ROUND(se.longitude, 1)
GROUP BY se.localizacao
HAVING COUNT(s.id) > 0
ORDER BY total_sos DESC;

-- 3. Drones em miss�o com alertas cr�ticos e SOS nas proximidades
-- Mostra drones ativos com contagem de alertas e SOS dentro da mesma regi�o (por arredondamento de coordenadas)

SELECT 
    d.nome,
    COUNT(DISTINCT a.id) AS total_alertas_criticos,
    COUNT(DISTINCT s.id) AS total_sos_proximos
FROM drones d
JOIN sensores se ON ROUND(se.latitude, 1) = ROUND(d.latitude, 1) AND ROUND(se.longitude, 1) = ROUND(d.longitude, 1)
JOIN alertas a ON a.sensor_id = se.id AND a.nivel = 'critico'
JOIN sos s ON ROUND(s.latitude, 1) = ROUND(d.latitude, 1) AND ROUND(s.longitude, 1) = ROUND(d.longitude, 1)
WHERE d.status = 'em_missao'
GROUP BY d.nome
HAVING COUNT(a.id) > 0
ORDER BY total_sos_proximos DESC;

-- 4. Abrigos com maior taxa de ocupa��o pr�ximos a ocorr�ncias de SOS
-- Lista os abrigos com SOS nas redondezas, mostrando ocupa��o e taxa percentual

SELECT 
    a.nome,
    COUNT(s.id) AS total_sos_proximos,
    a.capacidade,
    a.ocupacao_atual,
    ROUND((a.ocupacao_atual / a.capacidade) * 100, 2) AS taxa_ocupacao
FROM abrigos a
JOIN sos s ON ROUND(s.latitude, 1) = ROUND(a.latitude, 1) AND ROUND(s.longitude, 1) = ROUND(a.longitude, 1)
JOIN usuarios u ON u.id = s.usuario_id
GROUP BY a.nome, a.capacidade, a.ocupacao_atual
HAVING COUNT(s.id) > 0
ORDER BY taxa_ocupacao DESC;

-- 5. Tipos de sensores com maior m�dia de leitura e grande n�mero de alertas
-- Exibe o tipo de sensor, localiza��o, total de alertas e m�dia dos valores lidos

SELECT 
    se.tipo,
    se.localizacao,
    COUNT(DISTINCT a.id) AS total_alertas,
    AVG(ls.valor) AS media_valor_leitura
FROM sensores se
JOIN alertas a ON a.sensor_id = se.id
JOIN leituras_sensor ls ON ls.sensor_id = se.id
GROUP BY se.tipo, se.localizacao
HAVING COUNT(a.id) > 5
ORDER BY media_valor_leitura DESC;

