package org.aryalinux.javapress.data.dao.impl;

import java.util.List;

import org.aryalinux.javapress.data.dao.PageDAO;
import org.aryalinux.javapress.data.entities.Page;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class PageDAOImpl implements PageDAO {
	@Autowired
	private SessionFactory sessionFactory;

	public void save(Page page) {
		Session session = sessionFactory.openSession();
		session.save(page);
		session.close();
	}

	public void delete(Page page) {
		// TODO Auto-generated method stub

	}

	public void update(Page page) {
		// TODO Auto-generated method stub

	}

	@SuppressWarnings("unchecked")
	public List<Page> getPages() {
		Session session = sessionFactory.openSession();
		Query query = session.createQuery("from Page");
		List<Page> queries = (List<Page>) query.list();
		session.close();
		return queries;
	}

}
