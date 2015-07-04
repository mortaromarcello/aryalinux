package org.aryalinux.parser.appdb.dao;

import java.util.List;

import org.aryalinux.parser.appdb.model.PackageEntity;
import org.springframework.stereotype.Component;

@Component
public interface PackageDAO {
	public void savePackage(PackageEntity package1);

	public PackageEntity findById(Integer id);

	public List<PackageEntity> getAllPackages();

	public void updatePackage(PackageEntity package1);

	public void deletePackage(Integer id);
}
