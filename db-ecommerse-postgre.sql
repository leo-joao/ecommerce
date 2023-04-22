CREATE DATABASE IF NOT EXISTS db_ecommerce;

DROP TABLE IF EXISTS tb_persons;

--	Cria a tabela das pesoas
CREATE TABLE tb_persons (
  idperson SERIAL NOT NULL,
  desperson varchar(64) NOT NULL,
  desemail varchar(128) DEFAULT NULL,
  nrphone bigint DEFAULT NULL,
  dtregister timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (idperson)
);

--	Insere as pessoas iniciais
INSERT INTO tb_persons (idperson, desperson, desemail, nrphone, dtregister) VALUES
(1,'João Rangel','admin@hcode.com.br',2147483647,'2017-03-01 03:00:00'),
(99,'Léo João','leojoao2012@gmail.com.br',47988622969,'2023-04-21 15:00:00'),
(7,'Suporte','suporte@hcode.com.br',1112345678,'2017-03-15 16:10:27');

DROP TABLE IF EXISTS db_ecommerce.tb_users;

-- Cria a tabela usuários
CREATE TABLE tb_users (
  iduser SERIAL NOT NULL,
  idperson int NOT NULL,
  deslogin varchar(64) NOT NULL,
  despassword varchar(256) NOT NULL,
  inadmin smallint NOT NULL DEFAULT '0',
  dtregister timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (iduser),
  CONSTRAINT fk_users_persons FOREIGN KEY (idperson) REFERENCES tb_persons(idperson) ON DELETE NO ACTION ON UPDATE NO ACTION
  );

-- Insere os usuários iniciais
INSERT INTO tb_users (iduser, idperson, deslogin, despassword, inadmin, dtregister) VALUES
(1,1,'admin','$2y$12$YlooCyNvyTji8bPRcrfNfOKnVMmZA9ViM2A3IpFjmrpIbp5ovNmga',1,'2017-03-13 03:00:00'),
(7,7,'suporte','$2y$12$HFjgUm/mk1RzTy4ZkJaZBe0Mc/BA2hQyoUckvm.lFa6TesjtNpiMe',1,'2017-03-15 16:10:27');

DROP TABLE IF EXISTS tb_products;

-- Cria a tabela de Produtos
CREATE TABLE tb_products (
  idproduct SERIAL NOT NULL,
  desproduct varchar(64) NOT NULL,
  vlprice decimal(10,2) NOT NULL,
  vlwidth decimal(10,2) NOT NULL,
  vlheight decimal(10,2) NOT NULL,
  vllength decimal(10,2) NOT NULL,
  vlweight decimal(10,2) NOT NULL,
  desurl varchar(128) NOT NULL,
  dtregister timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (idproduct)
);

-- Insere os produtos iniciais
INSERT INTO tb_products (idproduct, desproduct, vlprice, vlwidth, vlheight, vllength, vlweight, desurl, dtregister) VALUES
(1,'Smartphone Android 7.0',999.95,75.00,151.00,80.00,167.00,'smartphone-android-7.0','2017-03-13 03:00:00'),
(2,'SmartTV LED 4K',3925.99,917.00,596.00,288.00,8600.00,'smarttv-led-4k','2017-03-13 03:00:00'),
(3,'Notebook 14\" 4GB 1TB',1949.99,345.00,23.00,30.00,2000.00,'notebook-14-4gb-1tb','2017-03-13 03:00:00');

DROP TABLE IF EXISTS tb_addresses;

-- Cria a tabela de endereços
CREATE TABLE tb_addresses (
  idaddress SERIAL NOT NULL,
  idperson int NOT NULL,
  desaddress varchar(128) NOT NULL,
  descomplement varchar(32) DEFAULT NULL,
  descity varchar(32) NOT NULL,
  desstate varchar(32) NOT NULL,
  descountry varchar(32) NOT NULL,
  nrzipcode int NOT NULL,
  dtregister timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (idaddress),
  CONSTRAINT fk_addresses_persons FOREIGN KEY (idperson) REFERENCES tb_persons (idperson) ON DELETE NO ACTION ON UPDATE NO ACTION
);

DROP TABLE IF EXISTS tb_carts;

-- Cria a tabela de carrinhos de compras
CREATE TABLE tb_carts (
  idcart int NOT NULL,
  dessessionid varchar(64) NOT NULL,
  iduser int DEFAULT NULL,
  idaddress int DEFAULT NULL,
  vlfreight decimal(10,2) DEFAULT NULL,
  dtregister timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (idcart),
  CONSTRAINT fk_carts_addresses FOREIGN KEY (idaddress) REFERENCES tb_addresses (idaddress) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT fk_carts_users FOREIGN KEY (iduser) REFERENCES tb_users (iduser) ON DELETE NO ACTION ON UPDATE NO ACTION
);

DROP TABLE IF EXISTS tb_cartsproducts;

-- Cria a tabela de produtos no carrinho
CREATE TABLE tb_cartsproducts (
  idcartproduct SERIAL NOT NULL,
  idcart int NOT NULL,
  idproduct int NOT NULL,
  dtremoved timestamp NOT NULL,
  dtregister timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (idcartproduct),
  CONSTRAINT fk_cartsproducts_carts FOREIGN KEY (idcart) REFERENCES tb_carts (idcart) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT fk_cartsproducts_products FOREIGN KEY (idproduct) REFERENCES tb_products (idproduct) ON DELETE NO ACTION ON UPDATE NO ACTION
);

DROP TABLE IF EXISTS db_ecommerce.tb_categories;

-- Cria a tabela de categorias
CREATE TABLE tb_categories (
  idcategory SERIAL NOT NULL,
  descategory varchar(32) NOT NULL,
  dtregister timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (idcategory)
);

DROP TABLE IF EXISTS tb_orders;

DROP TABLE IF EXISTS tb_ordersstatus;

-- Cria a tabela de status dos pedidos
CREATE TABLE tb_ordersstatus (
  idstatus SERIAL NOT NULL,
  desstatus varchar(32) NOT NULL,
  dtregister timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (idstatus)
);

-- Insere os dados iniciais
INSERT INTO tb_ordersstatus (idstatus, desstatus, dtregister) VALUES
(1,'Em Aberto','2017-03-13 03:00:00'),
(2,'Aguardando Pagamento','2017-03-13 03:00:00'),
(3,'Pago','2017-03-13 03:00:00'),
(4,'Entregue','2017-03-13 03:00:00');

-- Cria a tabela dos pedidos
CREATE TABLE tb_orders (
  idorder SERIAL NOT NULL,
  idcart int NOT NULL,
  iduser int NOT NULL,
  idstatus int NOT NULL,
  vltotal decimal(10,2) NOT NULL,
  dtregister timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (idorder),
  CONSTRAINT fk_orders_carts FOREIGN KEY (idcart) REFERENCES tb_carts (idcart) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT fk_orders_ordersstatus FOREIGN KEY (idstatus) REFERENCES tb_ordersstatus (idstatus) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT fk_orders_users FOREIGN KEY (iduser) REFERENCES tb_users (iduser) ON DELETE NO ACTION ON UPDATE NO ACTION
);

DROP TABLE IF EXISTS tb_productscategories;

-- Cria a tabela de categorias de produtos
CREATE TABLE tb_productscategories (
  idcategory int NOT NULL,
  idproduct int NOT NULL,
  PRIMARY KEY (idcategory,idproduct),
  CONSTRAINT fk_productscategories_categories FOREIGN KEY (idcategory) REFERENCES tb_categories (idcategory) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT fk_productscategories_products FOREIGN KEY (idproduct) REFERENCES tb_products (idproduct) ON DELETE NO ACTION ON UPDATE NO ACTION
);

DROP TABLE IF EXISTS tb_userslogs;

-- Cria a tabela de logs de usuário
CREATE TABLE tb_userslogs (
  idlog SERIAL NOT NULL,
  iduser int NOT NULL,
  deslog varchar(128) NOT NULL,
  desip varchar(45) NOT NULL,
  desuseragent varchar(128) NOT NULL,
  dessessionid varchar(64) NOT NULL,
  desurl varchar(128) NOT NULL,
  dtregister timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (idlog),
  CONSTRAINT fk_userslogs_users FOREIGN KEY (iduser) REFERENCES tb_users (iduser) ON DELETE NO ACTION ON UPDATE NO ACTION
);

DROP TABLE IF EXISTS tb_userspasswordsrecoveries;

-- Cria a tabela de recuperação de senhas
CREATE TABLE tb_userspasswordsrecoveries (
  idrecovery SERIAL NOT NULL,
  iduser int NOT NULL,
  desip varchar(45) NOT NULL,
  dtrecovery timestamp DEFAULT NULL,
  dtregister timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (idrecovery),
  CONSTRAINT fk_userspasswordsrecoveries_users FOREIGN KEY (iduser) REFERENCES tb_users (iduser) ON DELETE NO ACTION ON UPDATE NO ACTION
);

INSERT INTO tb_userspasswordsrecoveries (idrecovery, iduser, desip, dtrecovery, dtregister) VALUES
(1,7,'127.0.0.1',NULL,'2017-03-15 16:10:59'),
(2,7,'127.0.0.1','2017-03-15 13:33:45','2017-03-15 16:11:18'),
(3,7,'127.0.0.1','2017-03-15 13:37:35','2017-03-15 16:37:12');

-- Cria a função de recuperar a senhas
CREATE OR REPLACE FUNCTION sp_userspasswordsrecoveries_create(
	piduser INT,
	pdesip VARCHAR(45))
RETURNS VOID AS $$
BEGIN
  
  INSERT INTO tb_userspasswordsrecoveries (iduser, desip)
    VALUES(piduser, pdesip);
    
    SELECT * FROM tb_userspasswordsrecoveries
    WHERE idrecovery = LAST_INSERT_ID();
    
END;
$$ LANGUAGE plpgsql;

-- Cria a função de atualizar usuário
CREATE OR REPLACE FUNCTION public.sp_usersupdate_save(
    piduser INT,
    pdesperson VARCHAR(64),
    pdeslogin VARCHAR(64),
    pdespassword VARCHAR(256),
    pdesemail VARCHAR(128),
    pnrphone BIGINT,
    pinadmin SMALLINT
)
 RETURNS SETOF record
 LANGUAGE plpgsql
AS $function$
DECLARE
    vidperson INT;
BEGIN
    SELECT idperson INTO vidperson
    FROM tb_users
    WHERE iduser = piduser;

    UPDATE tb_persons
    SET 
        desperson = pdesperson,
        desemail = pdesemail,
        nrphone = pnrphone
    WHERE idperson = vidperson;

    UPDATE tb_users
    SET
        deslogin = pdeslogin,
        despassword = pdespassword,
        inadmin = pinadmin
    WHERE iduser = piduser;

    RETURN QUERY
    SELECT *
    FROM tb_users a
    INNER JOIN tb_persons b USING(idperson)
    WHERE a.iduser = piduser;

END;
$function$

-- Cria a função de deletar usuário
CREATE FUNCTION sp_users_delete(
	piduser INT)
RETURNS void AS $$
DECLARE
  vidperson INT;
BEGIN
  SELECT idperson INTO vidperson
  FROM tb_users
  WHERE iduser = piduser;

  DELETE FROM tb_users WHERE iduser = piduser;
  DELETE FROM tb_persons WHERE idperson = vidperson;
END;
$$ LANGUAGE plpgsql;

-- Cria a função de salvar um usuário
CREATE FUNCTION sp_users_save(
	pdesperson VARCHAR(64), 
	pdeslogin VARCHAR(64), 
	pdespassword VARCHAR(256), 
	pdesemail VARCHAR(128), 
	pnrphone BIGINT, 
	pinadmin SMALLINT)
RETURNS void AS $$
DECLARE
	vidperson INT;
BEGIN
	INSERT INTO tb_persons (desperson, desemail, nrphone)
    VALUES(pdesperson, pdesemail, pnrphone)    
    RETURNING idperson INTO vidperson;
    
    INSERT INTO tb_users (idperson, deslogin, despassword, inadmin)
    VALUES(vidperson, pdeslogin, pdespassword, pinadmin);
    
    SELECT * FROM tb_users a INNER JOIN tb_persons b USING(idperson) WHERE a.iduser = LAST_INSERT_ID();
    
END;
$$ LANGUAGE plpgsql;