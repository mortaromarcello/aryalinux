package org.aryalinux.javapress.data.entities;

import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.OneToMany;
import javax.persistence.Table;

@Entity
@Table(name = "roles")
public class Role extends BaseEntity {
	@Column
	private String name;
	@OneToMany(targetEntity = Right.class, fetch = FetchType.EAGER)
	private List<Right> rights;

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

}
