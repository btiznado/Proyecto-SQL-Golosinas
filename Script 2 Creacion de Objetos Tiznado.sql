-- ==========================================================
-- SCRIPT 2: CREACIÓN DE OBJETOS
-- PROYECTO: Distribuidora de Golosinas
-- AUTOR: Brayan Tiznado
-- ==========================================================

USE GoloDistribuidora;

-- Vista 1: Control de stock bajo
DROP VIEW IF EXISTS vw_productos_bajo_stock;
CREATE VIEW vw_productos_bajo_stock AS
SELECT 
    p.id_producto,
    p.nombre_prod,
    p.stock_actual,
    pr.razon_social AS proveedor
FROM PRODUCTOS p
JOIN PROVEEDORES pr ON p.id_proveedor = pr.id_proveedor
WHERE p.stock_actual < 20;

-- Vista 2: Hoja de ruta logística
DROP VIEW IF EXISTS vw_pedidos_pendientes;
CREATE VIEW vw_pedidos_pendientes AS
SELECT 
    pe.id_pedido,
    pe.fecha_pedido,
    c.nombre_negocio,
    c.direccion,
    c.dia_visita,
    pe.estado
FROM PEDIDOS pe
JOIN CLIENTES c ON pe.id_cliente = c.id_cliente
WHERE pe.estado IN ('Pendiente', 'Armado');


DELIMITER //

-- Función 1: Calcular el valor total de un pedido
DROP FUNCTION IF EXISTS fn_calcular_total_pedido //
CREATE FUNCTION fn_calcular_total_pedido (p_id_pedido INT) 
RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
    DECLARE v_total DECIMAL(10,2);
    
    SELECT COALESCE(SUM(dp.cantidad * p.precio_unitario), 0)
    INTO v_total
    FROM DETALLE_PEDIDOS dp
    JOIN PRODUCTOS p ON dp.id_producto = p.id_producto
    WHERE dp.id_pedido = p_id_pedido;
    
    RETURN v_total;
END //

-- Función 2: Consultar stock disponible
DROP FUNCTION IF EXISTS fn_stock_disponible //
CREATE FUNCTION fn_stock_disponible (p_id_producto INT) 
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE v_stock INT;
    
    SELECT stock_actual INTO v_stock
    FROM PRODUCTOS
    WHERE id_producto = p_id_producto;
    
    RETURN v_stock;
END //


-- SP 1: Crear un nuevo pedido
DROP PROCEDURE IF EXISTS sp_crear_pedido //
CREATE PROCEDURE sp_crear_pedido(IN p_id_cliente INT, OUT p_id_pedido INT)
BEGIN
    INSERT INTO PEDIDOS (id_cliente, fecha_pedido, estado)
    VALUES (p_id_cliente, CURDATE(), 'Pendiente');

    SET p_id_pedido = LAST_INSERT_ID();
END //

-- SP 2: Actualizar el estado de un pedido
DROP PROCEDURE IF EXISTS sp_actualizar_estado_pedido //
CREATE PROCEDURE sp_actualizar_estado_pedido(IN p_id_pedido INT, IN p_nuevo_estado VARCHAR(30))
BEGIN
    UPDATE PEDIDOS
    SET estado = p_nuevo_estado
    WHERE id_pedido = p_id_pedido;
END //



-- Trigger 1: Restar stock
DROP TRIGGER IF EXISTS trg_restar_stock_post_detalle //
CREATE TRIGGER trg_restar_stock_post_detalle
AFTER INSERT ON DETALLE_PEDIDOS
FOR EACH ROW
BEGIN
    UPDATE PRODUCTOS
    SET stock_actual = stock_actual - NEW.cantidad
    WHERE id_producto = NEW.id_producto;
END //

-- Trigger 2: Generar remito
DROP TRIGGER IF EXISTS trg_generar_remito_post_entrega //
CREATE TRIGGER trg_generar_remito_post_entrega
AFTER UPDATE ON PEDIDOS
FOR EACH ROW
BEGIN
    
    IF NEW.estado = 'Entregado' AND OLD.estado != 'Entregado' THEN
        INSERT INTO REMITOS (id_pedido, fecha_entrega)
        VALUES (NEW.id_pedido, CURDATE());
    END IF;
END //

DELIMITER ;