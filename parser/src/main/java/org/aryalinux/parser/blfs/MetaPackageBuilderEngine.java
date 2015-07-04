package org.aryalinux.parser.blfs;

import java.util.ArrayList;
import java.util.List;

import org.aryalinux.parser.commons.blfs.BLFSPackage;
import org.aryalinux.parser.postprocessor.blfs.EssentialsPackageCreator;
import org.aryalinux.parser.postprocessor.blfs.XorgServerPackageCreator;
import org.aryalinux.parser.utils.Util;

public class MetaPackageBuilderEngine {
	private static MetaPackageBuilderEngine instance;
	private List<MetaPackageBuilder> metaPackageBuilders;

	private MetaPackageBuilderEngine() {
		metaPackageBuilders = new ArrayList<MetaPackageBuilder>();
		metaPackageBuilders.add(new XorgServerPackageCreator());
		metaPackageBuilders.add(new EssentialsPackageCreator());
	}

	public static MetaPackageBuilderEngine instance() {
		if (instance == null) {
			instance = new MetaPackageBuilderEngine();
		}
		return instance;
	}

	public void createMetaPackageScripts() throws Exception {
		for (MetaPackageBuilder builder : metaPackageBuilders) {
			BLFSPackage pack = builder.createPackage();
			BLFSParser.packages.put(pack.getName(), pack);
			Util.writePackageScript(pack);
		}
	}
}
