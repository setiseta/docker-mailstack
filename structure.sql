CREATE TABLE IF NOT EXISTS mail_forward (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`email` varchar(255) NOT NULL DEFAULT '',
	`destination` varchar(255) NOT NULL DEFAULT '',
	PRIMARY KEY (`id`),
	UNIQUE KEY `email` (`email`)
) DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS mail_user (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`email` varchar(255) NOT NULL DEFAULT '',
	`password` varchar(128) NOT NULL DEFAULT '',
	`quota` bigint(13) NOT NULL DEFAULT '0',
	PRIMARY KEY (`id`),
	UNIQUE KEY `email` (`email`)
) DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS domains (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`domain` varchar(255) NOT NULL DEFAULT '',
	`dkimdns` text NOT NULL,
	`isemaildomain` tinyint(1) NOT NULL DEFAULT 0,
	PRIMARY KEY (`id`),
	UNIQUE KEY `domain` (`domain`)
) DEFAULT CHARSET=utf8;
