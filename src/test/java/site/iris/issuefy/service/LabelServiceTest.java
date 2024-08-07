package site.iris.issuefy.service;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

import java.util.List;
import java.util.Optional;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import site.iris.issuefy.entity.Label;
import site.iris.issuefy.repository.LabelRepository;
import site.iris.issuefy.response.LabelResponse;

class LabelServiceTest {

	@Mock
	private LabelRepository labelRepository;

	@InjectMocks
	private LabelService labelService;

	@BeforeEach
	void setUp() {
		MockitoAnnotations.openMocks(this);
	}

	@DisplayName("DB에 존재하지 않은 레이블은 생성한다.")
	@Test
	void findOrCreateLabel_Create() {
		// given
		String labelName = "new label name";
		String labelColor = "fffafa";
		Label newLabel = Label.of(labelName, labelColor);

		// 레이블이 존재하지 않을 때
		when(labelRepository.findByNameAndColor(labelName, labelColor)).thenReturn(Optional.empty());
		when(labelRepository.save(any(Label.class))).thenReturn(newLabel);

		// when
		Label result = labelService.findOrCreateLabel(labelName, labelColor);

		// then
		assertNotNull(result);
		assertEquals(labelName, result.getName());
		assertEquals(labelColor, result.getColor());
	}

	@DisplayName("DB에 존재하는 레이블은 생성하지 않는다")
	@Test
	void findOrCreateLabel_Find() {
		// given
		String labelName = "existing label name";
		String labelColor = "000000";
		Label existingLabel = Label.of(labelName, labelColor);

		// 레이블이 이미 존재할 때
		when(labelRepository.findByNameAndColor(labelName, labelColor)).thenReturn(Optional.of(existingLabel));

		// when
		Label result = labelService.findOrCreateLabel(labelName, labelColor);

		// then
		assertNotNull(result);
		assertEquals(labelName, result.getName());
		assertEquals(labelColor, result.getColor());
	}

	@DisplayName("이슈에 대한 레이블을 반환한다")
	@Test
	void getLabelsByIssueId_ReturnsLabels() {
		List<Label> labels = List.of(
			Label.of("test label name1", "000000"),
			Label.of("test label name2", "111111")
		);

		// given
		Long testIssueId = 1L;

		// when
		when(labelRepository.findByIssue_id(testIssueId)).thenReturn(Optional.of(labels));

		// then
		Optional<List<Label>> result = labelService.getLabelsByIssueId(testIssueId);
		assertTrue(result.isPresent());
		assertEquals(labels, result.get());
	}

	@DisplayName("이슈에 대한 레이블이 없다면 빈 옵셔널을 반환한다")
	@Test
	void getLabelsByIssueId_ReturnsEmpty() {
		// given
		Long testIssueId = 55L;

		// when
		when(labelRepository.findByIssue_id(testIssueId)).thenReturn(Optional.empty());

		// then
		Optional<List<Label>> result = labelService.getLabelsByIssueId(testIssueId);
		assertFalse(result.isPresent());
	}

	@DisplayName("레이블을 Response DTO로 변환한다")
	@Test
	void convertLabelsResponse_ReturnsDto() {
		// given
		Optional<List<Label>> optionalLabels = Optional.of(List.of(
			Label.of("test label name1", "000000"),
			Label.of("test label name2", "111111")
		));

		// when
		List<LabelResponse> result = labelService.convertLabelsResponse(optionalLabels);

		// then
		assertEquals(optionalLabels.get().size(), result.size());
	}

	@DisplayName("옵셔널이 비어있으면 빈 리스트를 반환한다")
	@Test
	void convertLabelsResponse_ReturnsEmpty() {
		// given
		Optional<List<Label>> optionalLabels = Optional.empty();

		// when
		List<LabelResponse> result = labelService.convertLabelsResponse(optionalLabels);

		// then
		assertEquals(0, result.size());
	}

	@DisplayName("이슈에 대한 모든 레이블을 저장한다")
	@Test
	void saveAllLabels() {
		// given
		List<Label> labels = List.of(
			Label.of("test label name1", "000000"),
			Label.of("test label name2", "111111")
		);

		// when
		labelService.saveAllLabels(labels);

		// then
		verify(labelRepository, times(1)).saveAll(anyList());
	}
}
