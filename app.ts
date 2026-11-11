import type { Answer, Sources } from './app.contract.d.ts';

export const grants = '';

const sources: Sources = {
  keep: async () => ({ ok: true }),
};
export const answer: Answer = (source, args, store, storage, native) => sources[source](args, store, storage, native);
