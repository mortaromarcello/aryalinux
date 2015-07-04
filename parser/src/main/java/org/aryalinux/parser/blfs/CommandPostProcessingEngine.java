package org.aryalinux.parser.blfs;

import java.util.ArrayList;
import java.util.List;

import org.aryalinux.parser.commons.blfs.BLFSCommandsPostProcessor;
import org.aryalinux.parser.commons.blfs.BLFSPackage;
import org.aryalinux.parser.postprocessor.blfs.DBusRemoveTestsProcessor;
import org.aryalinux.parser.postprocessor.blfs.DependencyFixer;
import org.aryalinux.parser.postprocessor.blfs.FreetypePostProcessor;
import org.aryalinux.parser.postprocessor.blfs.LLVMProcessor;
import org.aryalinux.parser.postprocessor.blfs.MesaPostProcessor;
import org.aryalinux.parser.postprocessor.blfs.MultithreadedMakeProcessor;
import org.aryalinux.parser.postprocessor.blfs.ProfileScriptFixer;
import org.aryalinux.parser.postprocessor.blfs.PythonFixer;
import org.aryalinux.parser.postprocessor.blfs.QTProcessor;
import org.aryalinux.parser.postprocessor.blfs.TestsDisablingProcessor;
import org.aryalinux.parser.postprocessor.blfs.X7CommandPostProcessor;
import org.aryalinux.parser.postprocessor.blfs.XorgPostProcessor;

public class CommandPostProcessingEngine {
	private static List<BLFSCommandsPostProcessor> postProcessors;
	private static CommandPostProcessingEngine instance;

	static {
		postProcessors = new ArrayList<BLFSCommandsPostProcessor>();
		postProcessors.add(new X7CommandPostProcessor());
		postProcessors.add(new TestsDisablingProcessor());
		postProcessors.add(new MultithreadedMakeProcessor());
		postProcessors.add(new DBusRemoveTestsProcessor());
		postProcessors.add(new LLVMProcessor());
		postProcessors.add(new QTProcessor());
		postProcessors.add(new FreetypePostProcessor());
		postProcessors.add(new XorgPostProcessor());
		postProcessors.add(new MesaPostProcessor());
		postProcessors.add(new DependencyFixer());
		postProcessors.add(new ProfileScriptFixer());
		postProcessors.add(new PythonFixer());
	}

	private CommandPostProcessingEngine() {
	}

	public static CommandPostProcessingEngine instance() {
		if (instance == null) {
			instance = new CommandPostProcessingEngine();
		}
		return instance;
	}

	public void process(BLFSPackage pack) throws Exception {
		for (BLFSCommandsPostProcessor commandPostProcessor : postProcessors) {
			commandPostProcessor.process(pack);
		}
	}
}
