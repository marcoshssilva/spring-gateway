package br.com.marcoshssilva.springcloudgateway;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.slf4j.Logger;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class SpringCloudGatewayApplicationTests {
    private static final Logger LOGGER = org.slf4j.LoggerFactory.getLogger(SpringCloudGatewayApplicationTests.class);

	@Test
	void contextLoads() {
        Assertions.assertDoesNotThrow(() -> {
            LOGGER.info("Context loaded successfully!");
        });
	}

}
