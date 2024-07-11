package site.iris.issuefy.component;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import lombok.Getter;
import lombok.NoArgsConstructor;

@Component
@Getter
@NoArgsConstructor
public class LambdaKey {
	@Value("${jwt.lambdaKey}")
	private String Key;

	public LambdaKey(String Key) {
		this.Key = Key;
	}
}
