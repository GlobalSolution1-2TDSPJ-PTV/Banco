SET SERVEROUTPUT ON;

DECLARE
  v_media NUMBER;
BEGIN
  FOR sensor IN (
    SELECT id, localizacao FROM sensores WHERE ativo = 'S'
  ) LOOP
    v_media := risco_medio_sensor(sensor.id);
    
    IF v_media > 80 THEN
      DBMS_OUTPUT.PUT_LINE('Sensor em ' || sensor.localizacao || ' com risco elevado: ' || v_media);
    END IF;
  END LOOP;
END;
/


DECLARE
  CURSOR c_abrigos IS
    SELECT nome, capacidade - ocupacao_atual AS vagas
    FROM abrigos
    WHERE capacidade > ocupacao_atual
    ORDER BY vagas DESC;

  v_nome abrigos.nome%TYPE;
  v_vagas NUMBER;
BEGIN
  OPEN c_abrigos;
  LOOP
    FETCH c_abrigos INTO v_nome, v_vagas;
    EXIT WHEN c_abrigos%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Abrigo: ' || v_nome || ' | Vagas disponíveis: ' || v_vagas);
  END LOOP;
  CLOSE c_abrigos;
END;
/

