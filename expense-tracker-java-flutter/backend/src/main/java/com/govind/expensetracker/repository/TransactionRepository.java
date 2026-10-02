package com.govind.expensetracker.repository;
import com.govind.expensetracker.entity.*; import org.springframework.data.jpa.repository.JpaRepository; import java.time.LocalDate; import java.util.List;
public interface TransactionRepository extends JpaRepository<Transaction,Long>{
 List<Transaction> findAllByOrderByTransactionDateDescIdDesc();
 List<Transaction> findByTransactionDateBetweenOrderByTransactionDateDescIdDesc(LocalDate from,LocalDate to);
 List<Transaction> findByTypeOrderByTransactionDateDescIdDesc(TransactionType type);
}
