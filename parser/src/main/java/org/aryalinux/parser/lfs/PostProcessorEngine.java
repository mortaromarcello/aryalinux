package org.aryalinux.parser.lfs;

import java.util.ArrayList;
import java.util.List;

import org.aryalinux.parser.commons.lfs.LFSPostProcessor;
import org.aryalinux.parser.commons.lfs.Step;
import org.aryalinux.parser.postprocessor.lfs.MultithreadedMakeCommandPostProcessor;
import org.aryalinux.parser.postprocessor.lfs.RemoveTestPostProcessor;

public class PostProcessorEngine {
	private static List<LFSPostProcessor> postProcessors;

	static {
		postProcessors = new ArrayList<LFSPostProcessor>();
		postProcessors.add(new RemoveTestPostProcessor());
		postProcessors.add(new MultithreadedMakeCommandPostProcessor());
	}

	public static void process(Step step) {
		for (LFSPostProcessor lfsPostProcessor : postProcessors) {
			lfsPostProcessor.process(step);
		}
	}
}
