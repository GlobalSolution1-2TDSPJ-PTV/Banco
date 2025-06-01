DECLARE
    v_usuario_id RAW(16);
    v_sensor_id RAW(16);
BEGIN
    -- Inserir usuários
    inserir_usuario('João Silva', 'joao@email.com', 'hash1', 'comum', '999999999', -23.550520, -46.633308);
    inserir_usuario('Maria Oliveira', 'maria@email.com', 'hash2', 'defesa_civil', '988888888', -23.551000, -46.632000);
    inserir_usuario('Carlos Souza', 'carlos@email.com', 'hash3', 'ong', '977777777', -23.552000, -46.634000);
    inserir_usuario('Ana Lima', 'ana@email.com', 'hash4', 'comum', '966666666', -23.553000, -46.635000);
    inserir_usuario('Pedro Santos', 'pedro@email.com', 'hash5', 'comum', '955555555', -23.554000, -46.636000);

    -- Recuperar ID de um usuário para usar depois
    SELECT id INTO v_usuario_id FROM usuarios WHERE email = 'joao@email.com';

    -- Inserir sensores
    inserir_sensor('Zona Norte', -23.550000, -46.630000, 'Pluviometro', 'S');
    inserir_sensor('Zona Sul', -23.560000, -46.640000, 'Barometro', 'S');
    inserir_sensor('Centro', -23.551000, -46.633000, 'Pluviometro', 'S');
    inserir_sensor('Leste', -23.552000, -46.632000, 'Higrômetro', 'S');
    inserir_sensor('Oeste', -23.553000, -46.631000, 'Termômetro', 'S');

    -- Recuperar um sensor para inserções relacionadas
    SELECT id INTO v_sensor_id FROM sensores WHERE localizacao = 'Zona Norte';

    -- Inserir leituras_sensor (valores variados para criar risco > 80 em alguns sensores)
    inserir_leitura_sensor(v_sensor_id, 85, 'mm');
    inserir_leitura_sensor(v_sensor_id, 90, 'mm');
    inserir_leitura_sensor(v_sensor_id, 75, 'mm');
    inserir_leitura_sensor(v_sensor_id, 80, 'mm');
    inserir_leitura_sensor(v_sensor_id, 95, 'mm');

    -- Inserir alertas, incluindo alguns críticos perto dos sensores
    inserir_alerta(v_sensor_id, 'Inundação', 'Alerta de enchente crítica', 'critico');
    inserir_alerta(v_sensor_id, 'Vento forte', 'Alerta de vento moderado', 'moderado');
    inserir_alerta(v_sensor_id, v_sensor_id, 'Alerta termômetro alto', 'baixo');
    inserir_alerta(v_sensor_id, 'Deslizamento', 'Alerta de deslizamento', 'critico');
    inserir_alerta(v_sensor_id, 'Alagamento', 'Alerta alagamento', 'critico');

    -- Inserir SOS próximos aos sensores
    inserir_sos(v_usuario_id, -23.550000, -46.630000, 'pendente');
    inserir_sos(v_usuario_id, -23.551000, -46.633000, 'em_atendimento');
    inserir_sos(v_usuario_id, -23.560000, -46.640000, 'resolvido');
    inserir_sos(v_usuario_id, -23.552000, -46.632000, 'pendente');
    inserir_sos(v_usuario_id, -23.553000, -46.631000, 'em_atendimento');

    -- Inserir abrigos próximos com ocupação
    inserir_abrigo('Abrigo Central', 100, 80, -23.550000, -46.630000, 'Defesa Civil');
    inserir_abrigo('Abrigo Norte', 50, 20, -23.551000, -46.633000, 'ONG Local');
    inserir_abrigo('Abrigo Sul', 120, 120, -23.560000, -46.640000, 'Prefeitura');
    inserir_abrigo('Abrigo Leste', 60, 30, -23.552000, -46.632000, 'Prefeitura');
    inserir_abrigo('Abrigo Oeste', 70, 50, -23.553000, -46.631000, 'Defesa Civil');

    -- Inserir drones em missão próximos aos sensores
    inserir_drone('Drone A', 'em_missao', 'Zona Norte', -23.550000, -46.630000);
    inserir_drone('Drone B', 'ativo', 'Zona Sul', -23.560000, -46.640000);
    inserir_drone('Drone C', 'em_missao', 'Centro', -23.551000, -46.633000);
    inserir_drone('Drone D', 'offline', 'Leste', -23.552000, -46.632000);
    inserir_drone('Drone E', 'em_missao', 'Oeste', -23.553000, -46.631000);

    COMMIT;
END;
/
