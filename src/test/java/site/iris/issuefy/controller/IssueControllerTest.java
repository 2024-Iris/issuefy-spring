package site.iris.issuefy.controller;

import static org.springframework.restdocs.mockmvc.MockMvcRestDocumentation.*;
import static org.springframework.restdocs.mockmvc.RestDocumentationRequestBuilders.*;
import static org.springframework.restdocs.request.RequestDocumentation.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;
import static site.iris.issuefy.ApiDocumentUtils.*;

import java.util.List;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.restdocs.AutoConfigureRestDocs;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.test.web.servlet.MockMvc;

import com.fasterxml.jackson.databind.ObjectMapper;

import site.iris.issuefy.dto.IssueResponse;
import site.iris.issuefy.service.IssueService;

@WebMvcTest(IssueController.class)
@AutoConfigureRestDocs
class IssueControllerTest {

	@Autowired
	private MockMvc mockMvc;

	@Autowired
	private ObjectMapper objectMapper;

	@MockBean
	private IssueService issueService;

	@DisplayName("해당 저장소에 오픈되어 있는 이슈를 조회한다.")
	@Test
	void getIssuesByRepoName() throws Exception {
		// given
		String repoName = "terminal";

		List<IssueResponse> responses = issueService.getIssuesByRepoName(repoName);

		// when & then
		mockMvc.perform(get("/{repo}/issues", repoName))
			.andExpect(status().isOk())
			.andDo(document("issuefy/issues/get",
				getDocumentRequest(),
				getDocumentResponse(),
				pathParameters(
					parameterWithName("repo").description("리포지토리 이름")
				)
			));
	}
}