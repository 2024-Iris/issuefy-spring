package site.iris.issuefy.service;

import java.security.Key;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.crypto.SecretKey;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jws;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import site.iris.issuefy.entity.Jwt;

@Component
public class TokenProvider {
	private Key key;

	public TokenProvider(@Value("${jwt.secretKey}") String secretKey) {
		this.key = Keys.hmacShaKeyFor(secretKey.getBytes());
	}

	public Jwt createJwt(Map<String, Object> claims) {
		String accessToken = createToken(claims, getExpireDateAccessToken());
		String refreshToken = createToken(new HashMap<>(), getExpireDateRefreshToken());

		return Jwt.of(accessToken, refreshToken);
	}

	private String createToken(Map<String, Object> claims, Date expireDate) {

		return Jwts.builder()
			.claims(claims)
			.expiration(expireDate)
			.signWith(key)
			.compact();
	}

	public Claims getClaims(String token) {

		return Jwts.parser()
			.verifyWith((SecretKey)key)
			.build()
			.parseSignedClaims(token)
			.getPayload();
	}

	public boolean isValidToken(String token) {
		try {
			Jws<Claims> claims = Jwts.parser()
				.verifyWith((SecretKey)key)
				.build()
				.parseSignedClaims(token);
			return claims.getPayload().getExpiration().after(new Date());
		} catch (JwtException | IllegalArgumentException e) {
			return false;
		}
	}

	private Date getExpireDateAccessToken() {
		long expireTimeMils = 1000L * 60 * 60 * 8;

		return new Date(System.currentTimeMillis() + expireTimeMils);
	}

	private Date getExpireDateRefreshToken() {
		long expireTimeMils = 1000L * 60 * 60 * 24 * 60;

		return new Date(System.currentTimeMillis() + expireTimeMils);
	}
}
