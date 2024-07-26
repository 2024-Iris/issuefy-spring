package site.iris.issuefy.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.RequestAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import site.iris.issuefy.model.dto.UserDto;
import site.iris.issuefy.model.dto.UserUpdateDto;
import site.iris.issuefy.service.UserService;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api")
public class UserController {

	private final UserService userService;

	@GetMapping("/user")
	public ResponseEntity<UserDto> getUserInfo(@RequestAttribute String githubId) {
		UserDto userDto = userService.getUserInfo(githubId);
		log.info("{} : User information request occurs", githubId);
		return ResponseEntity.ok().body(userDto);
	}

	@PatchMapping("/user/email")
	public ResponseEntity<String> updateEmail(@RequestAttribute String githubId,
		@RequestBody UserUpdateDto userUpdateDto) {
		userService.updateEmail(githubId, userUpdateDto.getEmail());
		log.info("{} : User email update request occurs", githubId);
		log.info(userUpdateDto.toString());
		return ResponseEntity.noContent().build();
	}

	@PatchMapping("/user/alert")
	public ResponseEntity<String> updateAlert(@RequestAttribute String githubId,
		@RequestBody UserUpdateDto userUpdateDto) {
		userService.updateAlert(githubId, userUpdateDto.isAlertStatus());
		log.info("{} : User alert update request occurs", githubId);
		log.info(userUpdateDto.toString());
		return ResponseEntity.noContent().build();
	}

}
