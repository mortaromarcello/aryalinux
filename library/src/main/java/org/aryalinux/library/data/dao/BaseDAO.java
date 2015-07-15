package org.aryalinux.library.data.dao;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

public interface BaseDAO<E> {
	void save(E ref);

	void udpate(E ref);

	void delete(E ref);

	List<E> list();

	E get(Serializable id);

	List<E> list(Map<String, Object> filters);
}
