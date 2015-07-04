package org.aryalinux.parser.appdb.dao;

import java.util.List;

import org.aryalinux.parser.appdb.model.PackageEntity;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component("packageDAO")
public class PackageDAOImpl implements PackageDAO {
	@Autowired
	private SessionFactory sessionFactory;

	public void savePackage(PackageEntity package1) {
		Session session = sessionFactory.openSession();
		session.saveOrUpdate(package1);
		session.close();
	}

	public PackageEntity findById(Integer id) {
		Session session = sessionFactory.openSession();
		PackageEntity pack = (PackageEntity) session.get(PackageEntity.class, id);
		session.close();
		return pack;
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	public List<PackageEntity> getAllPackages() {
		Session session = sessionFactory.openSession();
		List packages = session.createCriteria(PackageEntity.class).list();
		session.close();
		return packages;
	}

	public void updatePackage(PackageEntity package1) {
		Session session = sessionFactory.openSession();
		session.saveOrUpdate(package1);
		session.close();
	}

	public void deletePackage(Integer id) {
		Session session = sessionFactory.openSession();
		session.delete(session.get(PackageEntity.class, id));
		session.close();
	}

}
