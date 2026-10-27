import 'package:flutter_test/flutter_test.dart';
import 'package:quickqr/services/validators.dart';

void main() {
  test('empty input is rejected for every type', () {
    for (final t in ['Text', 'URL', 'Email', 'Phone']) {
      expect(validateQrInput(t, '   ').isValid, isFalse, reason: t);
    }
  });

  test('over-long input is rejected', () {
    expect(validateQrInput('Text', 'a' * 1001).isValid, isFalse);
    expect(validateQrInput('Text', 'a' * 1000).isValid, isTrue);
  });

  test('text is trimmed and otherwise untouched', () {
    expect(validateQrInput('Text', '  hello world ').data, 'hello world');
  });

  group('URL', () {
    test('adds https to bare domains', () {
      expect(validateQrInput('URL', 'example.com').data, 'https://example.com');
    });
    test('keeps existing http/https schemes', () {
      expect(
        validateQrInput('URL', 'http://example.com/a?b=1').data,
        'http://example.com/a?b=1',
      );
    });
    test('rejects junk', () {
      for (final bad in ['abc', 'hello world.com', 'ftp://example.com', 'a.']) {
        expect(validateQrInput('URL', bad).isValid, isFalse, reason: bad);
      }
    });
    test('allows localhost', () {
      expect(validateQrInput('URL', 'localhost:3000').isValid, isTrue);
    });
  });

  group('Email', () {
    test('accepts valid and prefixes mailto', () {
      expect(validateQrInput('Email', 'a@b.com').data, 'mailto:a@b.com');
    });
    test('rejects invalid', () {
      for (final bad in ['abc', 'a@b', '@b.com', 'a b@c.com']) {
        expect(validateQrInput('Email', bad).isValid, isFalse, reason: bad);
      }
    });
  });

  group('Phone', () {
    test('normalizes formatting and prefixes tel', () {
      expect(validateQrInput('Phone', '0773286562').data, 'tel:0773286562');
      expect(
        validateQrInput('Phone', '+94 (77) 328-6562').data,
        'tel:+94773286562',
      );
    });
    test('rejects letters and wrong lengths', () {
      for (final bad in ['abc', '12345', '1234567890123456', '07732a6562']) {
        expect(validateQrInput('Phone', bad).isValid, isFalse, reason: bad);
      }
    });
  });
}
