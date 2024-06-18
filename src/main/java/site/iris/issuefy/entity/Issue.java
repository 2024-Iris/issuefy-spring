package site.iris.issuefy.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@NoArgsConstructor
@Getter
@Table(name = "issue")
public class Issue {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;

	@ManyToOne
	@JoinColumn(name = "repository_id", nullable = false)
	private Repository repository;

	@Column(name = "title")
	private String title;

	@Column
	private boolean isStarred;

	@Column
	private boolean isRead;

	@Column
	private long ghIssueNumber;

	public Issue(Repository repository, String title, long ghIssueNumber) {
		this.repository = repository;
		this.title = title;
		this.ghIssueNumber = ghIssueNumber;
	}

	public static Issue of(Repository repository, String title, long ghIssueNumber) {
		return new Issue(repository, title, ghIssueNumber);
	}
}
