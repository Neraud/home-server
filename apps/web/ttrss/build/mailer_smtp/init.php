<?php
class mailer_smtp extends Plugin {
	private $host;

	function about() {
		return array(1.0,
			"Sends mail via SMTP using PHPMailer. Read README.txt before enabling.",
			"fox",
			1,
			"https://git.tt-rss.org/fox/ttrss-mailer-smtp");
	}

	function init($host) {
		$this->host = $host;

		$host->add_hook($host::HOOK_SEND_MAIL, $this);
	}

	function hook_send_mail($mailer, $params) {
		if (defined('SMTP_SERVER') && SMTP_SERVER) {

			$phpmailer = new PHPMailer\PHPMailer\PHPMailer();

			$phpmailer->isSMTP();

			$pair = explode(":", SMTP_SERVER, 2);
			$phpmailer->Host = $pair[0];
			$phpmailer->Port = $pair[1];
			$phpmailer->CharSet = "UTF-8";

			if (!$phpmailer->Port) $phpmailer->Port = 25;

			if (defined('SMTP_LOGIN') && SMTP_LOGIN) {
				$phpmailer->SMTPAuth = true;
				$phpmailer->Username = SMTP_LOGIN;
				$phpmailer->Password = SMTP_PASSWORD;
			}

			if (defined('SMTP_SECURE') && SMTP_SECURE) {
				$phpmailer->SMTPSecure = SMTP_SECURE;
			} else {
				$phpmailer->SMTPAutoTLS = false;
			}

			if (defined('SMTP_SKIP_CERT_CHECKS') && SMTP_SKIP_CERT_CHECKS) {
				$phpmailer->SMTPOptions = array(
				    'ssl' => array(
				        'verify_peer' => false,
				        'verify_peer_name' => false,
				        'allow_self_signed' => true
				    )
				);
			} elseif (defined('SMTP_CA_FILE') && SMTP_CA_FILE) {
				$phpmailer->SMTPOptions = array(
				    'ssl' => array(
                        'cafile' => SMTP_CA_FILE
				    )
				);
            }

			$from_name = $params["from_name"] ? $params["from_name"] : SMTP_FROM_NAME;
			$from_address = $params["from_address"] ? $params["from_address"] : SMTP_FROM_ADDRESS;

			$phpmailer->setFrom($from_address, $from_name);
			$phpmailer->addAddress($params["to_address"], $params["to_name"]);
			$phpmailer->Subject = $params["subject"];
			$phpmailer->CharSet = "UTF-8";

			if ($params["message_html"]) {
				$phpmailer->msgHTML($params["message_html"]);
				$phpmailer->AltBody = $params["message"];
			} else {
				$phpmailer->Body = $params["message"];
			}

			foreach ($params['headers'] as $header) {
				$phpmailer->addCustomHeader($header);
			}

			$rc = $phpmailer->send();

			if (!$rc)
				$mailer->set_error($rc . " " . $phpmailer->ErrorInfo);

			return $rc;
		}
	}

	function api_version() {
		return 2;
	}

}
?>
