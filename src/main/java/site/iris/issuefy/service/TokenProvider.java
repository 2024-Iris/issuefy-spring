package site.iris.issuefy.service;

import java.security.Key;
import java.util.Date;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;

@Component
public class TokenProvider {

	@Value("${jwt.secretKey}")
	private String secretKey;
	private final Key key;

	public TokenProvider() {
		this.key = Keys.hmacShaKeyFor(secretKey.getBytes());
	}

	public String createToken(Map<String, Object> claims, Date expireDate) {

		return Jwts.builder()
			.claims(claims)
			.expiration(expireDate)
			.signWith(key)
			.compact();
	}

	private Date getExpireDateAccessToken() {
		long expireTimeMils = 1000 * 60 * 60 * 8;

		return new Date(System.currentTimeMillis() + expireTimeMils);
	}
}
