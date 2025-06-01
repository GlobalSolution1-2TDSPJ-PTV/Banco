-- Função 1: Risco médio de enchente por sensor
CREATE OR REPLACE FUNCTION risco_medio_sensor(p_sensor_id IN RAW)
RETURN NUMBER
IS
  media NUMBER;
BEGIN
  SELECT AVG(valor) INTO media
  FROM leituras_sensor
  WHERE sensor_id = p_sensor_id;
  RETURN media;
END;
/

-- Função 2: Total de SOS por tipo de status
CREATE OR REPLACE FUNCTION total_sos_status(p_status IN VARCHAR2)
RETURN NUMBER
IS
  total NUMBER;
BEGIN
  SELECT COUNT(*) INTO total
  FROM sos
  WHERE status = p_status;
  RETURN total;
END;
/
