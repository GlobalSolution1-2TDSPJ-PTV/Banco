-- USUARIOS

-- Inserção
CREATE OR REPLACE PROCEDURE inserir_usuario(
    p_nome           IN VARCHAR2,
    p_email          IN VARCHAR2,
    p_senha_hash     IN VARCHAR2,
    p_tipo_usuario   IN VARCHAR2,
    p_telefone       IN VARCHAR2,
    p_latitude       IN NUMBER,
    p_longitude      IN NUMBER
) AS
BEGIN
    INSERT INTO usuarios (nome, email, senha_hash, tipo_usuario, telefone, latitude, longitude)
    VALUES (p_nome, p_email, p_senha_hash, p_tipo_usuario, p_telefone, p_latitude, p_longitude);
END;
/

BEGIN
    FOR i IN 1..5 LOOP
        inserir_usuario(
            p_nome         => 'Usuário ' || i,
            p_email        => 'usuario' || i || '@exemplo.com',
            p_senha_hash   => DBMS_RANDOM.STRING('x', 20),
            p_tipo_usuario => CASE MOD(i, 3) WHEN 0 THEN 'comum' WHEN 1 THEN 'defesa_civil' ELSE 'ong' END,
            p_telefone     => '1199999' || TO_CHAR(i),
            p_latitude     =>  -23.5 + i,
            p_longitude    => -46.6 + i
        );
    END LOOP;
END;
/

-- Atualização
CREATE OR REPLACE PROCEDURE atualizar_usuario(
    p_id             IN RAW,
    p_nome           IN VARCHAR2,
    p_email          IN VARCHAR2,
    p_tipo_usuario   IN VARCHAR2,
    p_telefone       IN VARCHAR2
) AS
BEGIN
    UPDATE usuarios
    SET nome = p_nome,
        email = p_email,
        tipo_usuario = p_tipo_usuario,
        telefone = p_telefone
    WHERE id = p_id;
END;
/

-- Exclusão
CREATE OR REPLACE PROCEDURE deletar_usuario(
    p_id IN RAW
) AS
BEGIN
    DELETE FROM usuarios WHERE id = p_id;
END;
/

--SENSORES

-- Inserção
CREATE OR REPLACE PROCEDURE inserir_sensor(
    p_localizacao  IN VARCHAR2,
    p_latitude     IN NUMBER,
    p_longitude    IN NUMBER,
    p_tipo         IN VARCHAR2,
    p_ativo        IN CHAR
) AS
BEGIN
    INSERT INTO sensores (localizacao, latitude, longitude, tipo, ativo)
    VALUES (p_localizacao, p_latitude, p_longitude, p_tipo, p_ativo);
END;
/

BEGIN
    FOR i IN 1..5 LOOP
        inserir_sensor(
            p_localizacao => 'Rua Sensor ' || i,
            p_latitude    => -23.6 + i,
            p_longitude   => -46.7 + i,
            p_tipo        => CASE MOD(i, 2) WHEN 0 THEN 'chuva' ELSE 'nível_água' END,
            p_ativo       => CASE WHEN MOD(i, 2) = 0 THEN 'S' ELSE 'N' END
        );
    END LOOP;
END;
/

-- Atualização
CREATE OR REPLACE PROCEDURE atualizar_sensor(
    p_id           IN RAW,
    p_localizacao  IN VARCHAR2,
    p_ativo        IN CHAR
) AS
BEGIN
    UPDATE sensores
    SET localizacao = p_localizacao,
        ativo = p_ativo
    WHERE id = p_id;
END;
/

-- Exclusão
CREATE OR REPLACE PROCEDURE deletar_sensor(
    p_id IN RAW
) AS
BEGIN
    DELETE FROM sensores WHERE id = p_id;
END;
/

--LEITURA DE SENSOR

-- Inserção
CREATE OR REPLACE PROCEDURE inserir_leitura_sensor(
    p_sensor_id  IN RAW,
    p_valor      IN NUMBER,
    p_unidade    IN VARCHAR2
) AS
BEGIN
    INSERT INTO leituras_sensor (sensor_id, valor, unidade)
    VALUES (p_sensor_id, p_valor, p_unidade);
END;
/

BEGIN
    FOR r IN (SELECT id FROM sensores FETCH FIRST 5 ROWS ONLY) LOOP
        FOR i IN 1..5 LOOP
            inserir_leitura_sensor(r.id, 10 + DBMS_RANDOM.VALUE(0, 100), 'mm');
        END LOOP;
    END LOOP;
END;
/


-- Atualização
CREATE OR REPLACE PROCEDURE atualizar_leitura_sensor(
    p_id         IN RAW,
    p_valor      IN NUMBER,
    p_unidade    IN VARCHAR2
) AS
BEGIN
    UPDATE leituras_sensor
    SET valor = p_valor,
        unidade = p_unidade
    WHERE id = p_id;
END;
/

-- Exclusão
CREATE OR REPLACE PROCEDURE deletar_leitura_sensor(
    p_id IN RAW
) AS
BEGIN
    DELETE FROM leituras_sensor WHERE id = p_id;
END;
/

--ALERTAS

-- Inserção
CREATE OR REPLACE PROCEDURE inserir_alerta(
    p_sensor_id IN RAW,
    p_tipo      IN VARCHAR2,
    p_mensagem  IN CLOB,
    p_nivel     IN VARCHAR2
) AS
BEGIN
    INSERT INTO alertas (sensor_id, tipo, mensagem, nivel)
    VALUES (p_sensor_id, p_tipo, p_mensagem, p_nivel);
END;
/

BEGIN
    FOR r IN (SELECT id FROM sensores FETCH FIRST 5 ROWS ONLY) LOOP
        inserir_alerta(r.id, 'enchente', 'Nível acima do normal', 'critico');
    END LOOP;
END;
/

-- Atualização
CREATE OR REPLACE PROCEDURE atualizar_alerta(
    p_id        IN RAW,
    p_nivel     IN VARCHAR2,
    p_resolvido IN CHAR
) AS
BEGIN
    UPDATE alertas
    SET nivel = p_nivel,
        resolvido = p_resolvido
    WHERE id = p_id;
END;
/

-- Exclusão
CREATE OR REPLACE PROCEDURE deletar_alerta(
    p_id IN RAW
) AS
BEGIN
    DELETE FROM alertas WHERE id = p_id;
END;
/

--SOS

-- Inserção
CREATE OR REPLACE PROCEDURE inserir_sos(
    p_usuario_id IN RAW,
    p_latitude   IN NUMBER,
    p_longitude  IN NUMBER,
    p_status     IN VARCHAR2
) AS
BEGIN
    INSERT INTO sos (usuario_id, latitude, longitude, status)
    VALUES (p_usuario_id, p_latitude, p_longitude, p_status);
END;
/

BEGIN
    FOR r IN (SELECT id, latitude, longitude FROM usuarios FETCH FIRST 5 ROWS ONLY) LOOP
        inserir_sos(r.id, r.latitude, r.longitude, 'pendente');
    END LOOP;
END;
/

-- Atualização
CREATE OR REPLACE PROCEDURE atualizar_sos(
    p_id     IN RAW,
    p_status IN VARCHAR2
) AS
BEGIN
    UPDATE sos
    SET status = p_status
    WHERE id = p_id;
END;
/

-- Exclusão
CREATE OR REPLACE PROCEDURE deletar_sos(
    p_id IN RAW
) AS
BEGIN
    DELETE FROM sos WHERE id = p_id;
END;
/

--ABRIGOS

-- Inserção
CREATE OR REPLACE PROCEDURE inserir_abrigo(
    p_nome           IN VARCHAR2,
    p_capacidade     IN NUMBER,
    p_ocupacao       IN NUMBER,
    p_latitude       IN NUMBER,
    p_longitude      IN NUMBER,
    p_responsavel    IN VARCHAR2
) AS
BEGIN
    INSERT INTO abrigos (nome, capacidade, ocupacao_atual, latitude, longitude, responsavel)
    VALUES (p_nome, p_capacidade, p_ocupacao, p_latitude, p_longitude, p_responsavel);
END;
/

BEGIN
    FOR i IN 1..5 LOOP
        inserir_abrigo(
            p_nome        => 'Abrigo Zona ' || i,
            p_capacidade  => 100 + i * 10,
            p_ocupacao    => 10 + i,
            p_latitude    => -23.55 + i,
            p_longitude   => -46.65 + i,
            p_responsavel => 'Responsável ' || i
        );
    END LOOP;
END;
/
-- Atualização
CREATE OR REPLACE PROCEDURE atualizar_abrigo(
    p_id             IN RAW,
    p_ocupacao       IN NUMBER
) AS
BEGIN
    UPDATE abrigos
    SET ocupacao_atual = p_ocupacao
    WHERE id = p_id;
END;
/

-- Exclusão
CREATE OR REPLACE PROCEDURE deletar_abrigo(
    p_id IN RAW
) AS
BEGIN
    DELETE FROM abrigos WHERE id = p_id;
END;
/

--DRONES

-- Inserção
CREATE OR REPLACE PROCEDURE inserir_drone (
    p_nome        IN VARCHAR2,
    p_status      IN VARCHAR2,
    p_local_atual IN VARCHAR2,
    p_latitude    IN NUMBER,
    p_longitude   IN NUMBER
) AS
BEGIN
    INSERT INTO drones (nome, status, local_atual, latitude, longitude)
    VALUES (p_nome, p_status, p_local_atual, p_latitude, p_longitude);
END;
/


BEGIN
    FOR i IN 1..5 LOOP
        inserir_drone(
            p_nome        => 'Drone ' || i,
            p_status      => CASE MOD(i,3) WHEN 0 THEN 'ativo' WHEN 1 THEN 'em_missao' ELSE 'offline' END,
            p_local_atual => 'Setor ' || i,
            p_latitude    => -23.56 + i,
            p_longitude   => -46.66 + i
        );
    END LOOP;
END;
/


-- Atualização
CREATE OR REPLACE PROCEDURE atualizar_drone(
    p_id        IN RAW,
    p_status    IN VARCHAR2,
    p_local     IN VARCHAR2
) AS
BEGIN
    UPDATE drones
    SET status = p_status,
        local_atual = p_local
    WHERE id = p_id;
END;
/

-- Exclusão
CREATE OR REPLACE PROCEDURE deletar_drone(
    p_id IN RAW
) AS
BEGIN
    DELETE FROM drones WHERE id = p_id;
END;
/


