package org.aryalinux.library.data.dao.impl;

import java.io.Serializable;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.aryalinux.library.data.dao.BaseDAO;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;

public class BaseDAOImpl<E> implements BaseDAO<E> {
	@Autowired
	private SessionFactory sessionFactory;
	private Class<E> classRef;

	public BaseDAOImpl(Class<E> ref) {
		this.classRef = ref;
	}

	public void save(E ref) {
		Session session = sessionFactory.openSession();
		session.save(ref);
		session.close();
	}

	public void udpate(E ref) {
		Session session = sessionFactory.openSession();
		session.saveOrUpdate(ref);
		session.close();
	}

	public void delete(E ref) {
		Session session = sessionFactory.openSession();
		session.delete(ref);
		session.close();
	}

	@SuppressWarnings("unchecked")
	public List<E> list() {
		Session session = sessionFactory.openSession();
		System.out.println("from " + classRef);
		Query query = session.createQuery("from " + classRef);
		List<E> list = query.list();
		session.close();
		return list;
	}

	@SuppressWarnings("unchecked")
	public E get(Serializable id) {
		Session session = sessionFactory.openSession();
		E ref = (E) session.get(classRef, id);
		session.close();
		return ref;
	}

	@SuppressWarnings("unchecked")
	public List<E> list(Map<String, Object> filters) {
		Session session = sessionFactory.openSession();
		System.out.println("from " + classRef);
		String sql = "from " + classRef + "z ";
		if (filters.entrySet().size() > 0) {
			sql = sql + "where ";
			int count = 0;
			for (Entry<String, Object> entry : filters.entrySet()) {
				if (count == 0) {
					sql = sql + "z." + entry.getKey() + " =: param" + count
							+ " ";
				} else {
					sql = sql + "and z." + entry.getKey() + " =: param" + count
							+ " ";
				}
				count++;
			}
		}
		Query query = session.createQuery(sql);
		int count = 0;
		for (Entry<String, Object> entry : filters.entrySet()) {
			query.setParameter("param" + count, entry.getValue());
			count++;
		}

		List<E> list = query.list();
		session.close();
		return list;
	}

}
