import 'package:rust_core/iter.dart';

/// A contiguous sequence of elements in a [List]. Slices are a view into a list, and do not own their own data. 
/// Be careful with slices, as they can be invalidated if the underlying list is modified and thus lead to a runtime error.
// ignore: library_private_types_in_public_api
extension type Slice<T>._(RIterator<T> list){

  Slice(List<T> list, int start, int end) : list = RIterator<T>(list.getRange(start, end));

// align_to
// align_to_mut
// array_chunks
// array_chunks_mut
// array_windows
// as_ascii
// as_ascii_unchecked
// as_bytes
// as_chunks
// as_chunks_mut
// as_chunks_unchecked
// as_chunks_unchecked_mut
// as_mut_ptr
// as_mut_ptr_range
// as_ptr
// as_ptr_range
// as_rchunks
// as_rchunks_mut
// as_simd
// as_simd_mut
// as_str
// binary_search
// binary_search_by
// binary_search_by_key
// chunks
// chunks_exact
// chunks_exact_mut
// chunks_mut
// clone_from_slice
// contains
// copy_from_slice
// copy_within
// ends_with
// eq_ignore_ascii_case
// escape_ascii
// fill
// fill_with
// first
// first_chunk
// first_chunk_mut
// first_mut
// flatten
// flatten_mut
// get
// get_many_mut
// get_many_unchecked_mut
// get_mut
// get_unchecked
// get_unchecked_mut
// group_by
// group_by_mut
// is_ascii
// is_empty
// is_sorted
// is_sorted_by
// is_sorted_by_key
// iter
// iter_mut
// last
// last_chunk
// last_chunk_mut
// last_mut
// len
// make_ascii_lowercase
// make_ascii_uppercase
// partition_dedup
// partition_dedup_by
// partition_dedup_by_key
// partition_point
// rchunks
// rchunks_exact
// rchunks_exact_mut
// rchunks_mut
// reverse
// rotate_left
// rotate_right
// rsplit
// rsplit_array_mut
// rsplit_array_ref
// rsplit_mut
// rsplit_once
// rsplitn
// rsplitn_mut
// select_nth_unstable
// select_nth_unstable_by
// select_nth_unstable_by_key
// sort_floats
// sort_floats
// sort_unstable
// sort_unstable_by
// sort_unstable_by_key
// split
// split_array_mut
// split_array_ref
// split_at
// split_at_mut
// split_at_mut_unchecked
// split_at_unchecked
// split_first
// split_first_chunk
// split_first_chunk_mut
// split_first_mut
// split_inclusive
// split_inclusive_mut
// split_last
// split_last_chunk
// split_last_chunk_mut
// split_last_mut
// split_mut
// split_once
// splitn
// splitn_mut
// starts_with
// strip_prefix
// strip_suffix
// swap
// swap_unchecked
// swap_with_slice
// take
// take_first
// take_first_mut
// take_last
// take_last_mut
// take_mut
// trim_ascii
// trim_ascii_end
// trim_ascii_start
// windows
}