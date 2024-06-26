package site.iris.issuefy.entity;

import jakarta.persistence.CascadeType;
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
@Table(name = "repository")
@Getter
@NoArgsConstructor
public class Repository {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;

	@ManyToOne(cascade = CascadeType.PERSIST)
	@JoinColumn(name = "org_id", nullable = false)
	private Org org;

	@Column(name = "name")
	private String name;

	@Column
	private boolean isStarred;

	@Column
	private long ghRepoId;

	public Repository(Org org, String name, long ghRepoId) {
		this.org = org;
		this.name = name;
		this.isStarred = false;
		this.ghRepoId = ghRepoId;
	}

	@Override
	public String toString() {
		return "Repository{" +
			"id=" + id +
			", org=" + org +
			", name='" + name + '\'' +
			'}';
	}
}
