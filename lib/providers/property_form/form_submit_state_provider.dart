import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'form_submit_state_provider.g.dart';

@riverpod
class FormSubmitState extends _$FormSubmitState {
  @override
  bool build() => false;

  void setSubmitting(bool value) => state = value;
}

@riverpod
class FormDraftSavingState extends _$FormDraftSavingState {
  @override
  bool build() => false;

  void setSaving(bool value) => state = value;
}
